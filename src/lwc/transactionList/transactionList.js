import {LightningElement, wire, track} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {registerListener, unregisterAllListeners} from 'c/pubsub';
import {reduceErrors} from 'c/ldsUtils';
import getTransactions from '@salesforce/apex/Payment2.getTransactions';

const columns = [
	{label: 'Transaction Date', fieldName: 'Transaction_Date__c', type: 'date'},
	{label: 'Payment Id', fieldName: 'Name', type: 'text'},
	{label: 'Pay.gov Id', fieldName: 'Remote_Tracking_Id__c', type: 'text'},
	{label: 'Amount', fieldName: 'Transaction_Amount__c', type: 'currency', typeAttributes: { currencyCode: 'USD'}}
];

export default class TransactionList extends LightningElement {

	@track records;
	@track error;
	@track retrievingData = false;
	@track selectedRows = [];
	@track selectedTotal = 0;
	@track recordColumns = columns;


	@wire(CurrentPageReference) pageRef; // Required by pubsub
	get hasData() {
		if (this.records) {
			return true;
		}
		return false;
	}

	get dataReceived() {
		if (this.records || this.retrievingData == true) {
			return true;
		}
		return false;
	}

	connectedCallback() {
		// subscribe to transactionListUpdate event
		registerListener('transactionListUpdate', this.handleTransactionListUpdate, this);
	}
	disconnectedCallback() {
		// unsubscribe from all events
		unregisterAllListeners(this);
	}

	handleTransactionListUpdate(searchCriteria) {
		this.records = undefined;
		let obj = JSON.parse(searchCriteria);
		this.retrievingData = true;

		getTransactions({accountType: obj.accountType, paymentMethod: obj.paymentMethod,
			transactionType: obj.transactionType, fromDateString: obj.fromDate, toDateString: obj.toDate})
			.then(result => {
				if (! this.isEmpty(result)) {
					//Go through the returned data
					let rows = result;
					this.selectedRows = [];
					this.selectedTotal = 0;
					for (let i = 0; i < rows.length; i++) {
						let row = rows[i];
						this.selectedRows.push(row.Id);  //Select all Rows by default
						this.selectedTotal += row.Transaction_Amount__c;  //Add up the total amount
					}
					this.records = result;
				}
				this.retrievingData = false;
				this.error = undefined;
			})
			.catch(error => {
				this.retrievingData = false;
				this.error = reduceErrors(error).join(', ');
			});
	}

	isEmpty(obj) {
		for(let key in obj) {
			if(obj.hasOwnProperty(key))
				return false;
		}
		return true;
	}

	handleRowSelection(event) {
		const selectedRows = event.detail.selectedRows;
		this.selectedTotal = 0;
		this.selectedRows = [];

		for (let i = 0; i < selectedRows.length; i++) {
			this.selectedRows.push(selectedRows[i].Id);
			this.selectedTotal += selectedRows[i].Transaction_Amount__c;
		}
	}

	handleDownload() {
		console.log("handleDownload.  TODO");
	}

}