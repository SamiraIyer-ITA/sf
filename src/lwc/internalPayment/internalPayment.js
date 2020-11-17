import {LightningElement, track, api} from 'lwc';
import {reduceErrors} from 'c/ldsUtils';
import beginPayment from '@salesforce/apex/Payments2Service.beginPayment';
import {NavigationMixin} from 'lightning/navigation';

export default class InternalPayment extends NavigationMixin(LightningElement) {

	@api recordId;  //The order Id
	@track error;
	@track redirectUrl

	connectedCallback() {
		beginPayment({orderId: this.recordId})
			.then(result => {
				let returnObject = JSON.parse(result);
				this.error = undefined;
				if (returnObject.redirectUrl) {
					//Redirect to Pay.gov
					this.dispatchEvent(new CustomEvent("redirect", {
						detail: {redirectUrl: returnObject.redirectUrl}
					}));
					//Close the quick action modal.
					//Done as a separate event to avoid the modal closing too soon.
					this.dispatchEvent(new CustomEvent("closemodal"));
				}

				if (returnObject.error) {
					this.error = "Error: " + returnObject.error;
				}
			})
			.catch(error => {
				this.error = reduceErrors(error).join(', ');
				console.log(this.error);
			});
	}

}