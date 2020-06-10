import {LightningElement, track, api} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {reduceErrors} from 'c/ldsUtils';
import getPaymentDetails from '@salesforce/apex/PaymentDetailsLightningController2.getPaymentDetails';

export default class PaymentDetails2 extends LightningElement {

	@api recordId;  //The payment record Id
	@api objectApiName;
	@api flexipageRegionWidth;
	@track detailsRetrieved = false;
	@track record;

	get isCreditCard() {
		if (this.record) {
			return this.record.isCreditCard;
		} else {
			return false;
		}
	}

	get isAch() {
		if (this.record) {
			return this.record.isAch;
		} else {
			return false;
		}
	}

	connectedCallback() {
		getPaymentDetails({paymentId: this.recordId})
			.then(result => {
				this.detailsRetrieved = true;
				if (result) {
					this.record = JSON.parse(result);
				}
			})
			.catch(error => {
				this.error = reduceErrors(error).join(', ');
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'Error Retrieving Payment Details',
						message: reduceErrors(error).join(', '),
						variant: 'error'
					})
				);
				this.detailsRetrieved = true;
			});
	}

}