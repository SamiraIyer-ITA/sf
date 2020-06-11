import {LightningElement, track, api} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {reduceErrors} from 'c/ldsUtils';
import {getQueryParameters} from 'c/getQueryParameters';
import startElectronicPayment from '@salesforce/apex/Payment2.startElectronicPayment';
import authorizePayment from '@salesforce/apex/Payment2.authorizePayment';
import getOrder from '@salesforce/apex/Payment2.getOrder';
import {NavigationMixin} from 'lightning/navigation';

export default class Payment extends NavigationMixin(LightningElement) {

	@api recordId;  //The Order record Id or Contract record Id.
	@api objectApiName;
	@api paymentPage;
	@api paymentConfirmationPage;
	@api flexipageRegionWidth;
	@track record;
	@track error;
	@track buttonClicked = false;
	@track orderStatus;
	@track showOrderList = false;
	parameters = [];
	contractId;

	connectedCallback() {
		//Display a message if returned to this page after canceling a payment
		this.parameters = getQueryParameters();
		if (this.parameters.cancel && this.parameters.cancel=="true") {
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'Payment Cancellation',
					message: 'Your payment has been canceled.',
					variant: 'info'
				})
			);
		}

		if (this.objectApiName == "Order") {
			getOrder({orderId: this.recordId})
				.then(result => {
					this.record = result;
					this.error = undefined;
					this.orderStatus = this.record.Status;
					this.contractId = this.record.ContractId;
				})
				.catch(error => {
					this.error = reduceErrors(error).join(', ');
					this.record = undefined;
				});
		} else if (this.objectApiName == "Contract") {
			this.contractId = this.recordId;
		}
	}

	get isOrder() {
		return this.objectApiName == "Order";
	}

	get showDeterminingTotal() {
		if (this.objectApiName == "Order" && !this.record.TotalAmount) {
			return true;
		}
		return false;
	}

	get isContract() {
		return this.objectApiName == "Contract";
	}

	get totalAmount() {
		return this.record.TotalAmount;
	}

	get orderPaid() {
		if (this.objectApiName == 'Contract') {
			return false;
		} else {
			if (this.orderStatus) {
				return this.orderStatus == "Paid";
			} else {
				return true;  //Hide the component until it's determined the order hasn't been paid
			}
		}
	}

	handlePay() {
		if (!this.buttonClicked) {
			this.buttonClicked = true;
			this.payment(this.recordId, this.record.Type);
		}
	}

	handleContractPayment() {
		if (!this.buttonClicked) {
			this.showOrderList = true;
		}
	}

	payment(orderRecords, productType) {
		/*NOTE: Do not combine startElectronicPayment() and authorizePayment().  They are broken up this way because
		  authorizePayment() includes a callout and startElectronicPayment() include DML.*/
		startElectronicPayment({accountType: productType, contractId: this.contractId, orderIds: orderRecords,
			userId: null, paymentPage: this.paymentPage, paymentConfirmationPage: this.paymentConfirmationPage,
			objectApiName: this.objectApiName, recordId: this.recordId})
			.then(result => {
				authorizePayment({authenticationDetailsString: result})
					.then(result => {
						//Redirect to the external payment processor page
						this[NavigationMixin.Navigate]({
							type: "standard__webPage",
							attributes: {
								url: result,
								replace: true
							}
						});
						//Navigate to the home page
						this[NavigationMixin.Navigate]({
							type: "comm__namedPage",
							attributes: {
								pageName: "home"
							}
						});
					})
					.catch(error => {
						this.buttonClicked = false;
						this.error = reduceErrors(error).join(', ');
						this.dispatchEvent(
							new ShowToastEvent({
								title: 'Error redirecting to payment site',
								message: reduceErrors(error).join(', '),
								variant: 'error'
							})
						);
					});
			})
			.catch(error => {
				this.buttonClicked = false;
				this.error = reduceErrors(error).join(', ');
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'Error creating payment record',
						message: reduceErrors(error).join(', '),
						variant: 'error'
					})
				);
			});
	}

	get buttonClicked() {
		return this.buttonClicked;
	}

	handleOrderListCancel() {
		this.showOrderList = false;
		this.buttonClicked = false;
	}

	handleOrdersSelected(event) {
		let selectedOrders = event.detail.selectedOrders;
		let productType = event.detail.productType;
		this.showOrderList = false;
		this.buttonClicked = true;
		this.payment(selectedOrders, productType);
	}

}