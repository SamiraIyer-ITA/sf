import {LightningElement, track, api} from 'lwc';
import {reduceErrors} from 'c/ldsUtils';
import {getQueryParameters} from 'c/getQueryParameters';
import confirmPayment from '@salesforce/apex/Payment2.confirmPayment';
import {NavigationMixin} from 'lightning/navigation';

export default class PaymentConfirmation extends NavigationMixin(LightningElement) {

	@api failedPaymentPageName;
	@api paymentPage;
	@api paymentPageType;
	@track error;
	@track confirmed = false;
	parameters = {};

	connectedCallback() {
		this.parameters = getQueryParameters();
		let orderIdArray = this.parameters.orderIds.split(',+');
		confirmPayment({paymentId: this.parameters.paymentId, accountType: this.parameters.acctType, token: this.parameters.token, orderIds: orderIdArray})
			.then(result => {
				this.confirmed = true;
			})
			.catch(error => {
				this.error = reduceErrors(error).join(', ');
			});
	}

	handleClick() {
		//Redirect to the starting page (the order or contract detail page)
		this[NavigationMixin.Navigate]({
			type: "standard__recordPage",
			attributes: {
				"recordId": this.parameters.recordId,
				"objectApiName": this.parameters.objectApiName,
				"actionName": "view"
			}
		});
	}

	get isConfirmed() {
		return this.confirmed;
	}

	get showSpinner() {
		if (this.error || this.isConfirmed) {
			return false;
		}
		return true;
	}
}