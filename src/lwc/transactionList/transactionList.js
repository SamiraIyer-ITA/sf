import {LightningElement, wire, track} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {registerListener, unregisterAllListeners} from 'c/pubsub';
import {reduceErrors} from 'c/ldsUtils';
import getTransactions from '@salesforce/apex/Payment2.getTransactions';
import LWCStyles from '@salesforce/resourceUrl/LWCStyles';
import {loadStyle} from 'lightning/platformResourceLoader';

const columns = [
	{label: 'Transaction Date', fieldName: 'Transaction_Date__c', type: 'date'},
	{label: 'Payment Id', fieldName: 'Name', type: 'text'},
	{label: 'Pay.gov Id', fieldName: 'Remote_Tracking_Id__c', type: 'text'},
	{label: 'Amount', fieldName: 'Transaction_Amount__c', type: 'currency', typeAttributes: { currencyCode: 'USD'}, cellAttributes: { class: { fieldName: "Amount-Color" }, alignment: "left"}}
];

export default class TransactionList extends LightningElement {

	@track records;
	@track error;
	@track retrievingData = false;
	@track selectedRows = [];
	@track selectedTotal = 0;
	@track recordColumns = columns;
	@track tableTitle;
	obj;  //Object populated from the transactionCriteria LWC

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
		//First, load the styles needed for the component (used for text coloring in the datatable)
		Promise.all([
			loadStyle(this, LWCStyles)
		]).then(() => {
			// subscribe to transactionListUpdate event
			registerListener('transactionListUpdate', this.handleTransactionListUpdate, this);
		});
	}
	disconnectedCallback() {
		// unsubscribe from all events
		unregisterAllListeners(this);
	}

	handleTransactionListUpdate(searchCriteria) {
		this.records = undefined;
		this.obj = JSON.parse(searchCriteria);
		this.retrievingData = true;

		getTransactions({accountType: this.obj.accountType, paymentMethod: this.obj.paymentMethod,
			transactionType: this.obj.transactionType, fromDateString: this.obj.fromDate, toDateString: this.obj.toDate,
			downloaded: this.obj.downloaded})
			.then(result => {
				if (! this.isEmpty(result)) {
					//Go through the returned data
					let rows = result;
					let rowBuilder = [];
					this.selectedRows = [];
					this.selectedTotal = 0;
					//Add a field in for the color of the amount field.  The value of the field must match a css style.
					let pair;
					for (let i = 0; i < rows.length; i++) {
						let row = rows[i];
						if (this.obj.transactionType == "Payments") {
							pair = {"Amount-Color": "color-green"};
						} else {
							//Refunds
							pair = {"Amount-Color": "color-red"};
						}
						row = {...row, ...pair};
						rowBuilder.push(row);
						this.selectedRows.push(row.Id);  //Select all Rows by default
						this.selectedTotal += row.Transaction_Amount__c;  //Add up the total amount
					}
					this.tableTitle = this.obj.downloaded + " " + this.obj.accountType + " " + this.obj.paymentMethod + " "
						+ this.obj.transactionType + " for " + this.obj.fromDate + " - " + this.obj.toDate;
					this.records = rowBuilder;
					//console.log(JSON.stringify(this.records));
				}
				this.retrievingData = false;
				this.error = undefined;
			})
			.catch(error => {
				this.tableTitle = undefined;
				this.retrievingData = false;
				this.error = reduceErrors(error).join(', ');
			});
	}

	isEmpty(result) {
		for(let key in result) {
			if(result.hasOwnProperty(key))
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

	handleToExcel() {
		let columnHeader = ["Transaction Date", "Payment Id", "Pay.gov Id", "Amount", "Account Type", "Record Id", "Payment Type"];  // This array holds the Column headers to be displayed
		let jsonKeys = ["Transaction_Date__c", "Name", "Remote_Tracking_Id__c", "Transaction_Amount__c", "Account_Type__c", "Id", "Payment_Type__c"]; // This array holds the keys in the json data

		let jsonRecordsData = [];
		//Only export the selected records
		for (let i = 0; i < this.selectedRows.length; i++) {
			for (let x = 0; x < this.records.length; x++) {
				if (this.selectedRows[i] === this.records[x].Id) {
					jsonRecordsData.push(this.records[x]);
					break;
				}
			}
		}

		//let jsonRecordsData = this.records;
		let csvSeparator = ",";
		let newLineCharacter = "\n";
		let csvIterativeData = this.tableTitle + newLineCharacter + newLineCharacter;
		csvIterativeData += columnHeader.join(csvSeparator);
		csvIterativeData += newLineCharacter;
		for (let i = 0; i < jsonRecordsData.length; i++) {
			let counter = 0;
			for (let iteratorObj in jsonKeys) {
				let dataKey = jsonKeys[iteratorObj];
				if (counter > 0) {
					csvIterativeData += csvSeparator;
				}
				if (jsonRecordsData[i][dataKey] !== null && jsonRecordsData[i][dataKey] !== undefined) {
					//Change the PLASTIC_CARD value to Credit Card
					if (dataKey === 'Payment_Type__c' && jsonRecordsData[i][dataKey] === 'PLASTIC_CARD') {
						csvIterativeData += '"Credit Card"';
					} else if (this.obj.transactionType === "Refunds" && dataKey === 'Transaction_Amount__c') {
						//Make the amount negative if it's a refund
						csvIterativeData += '"-' + jsonRecordsData[i][dataKey] + '"';
					} else {
						csvIterativeData += '"' + jsonRecordsData[i][dataKey] + '"';
					}
				} else {
					csvIterativeData += '""';
				}
				counter++;
			}
			csvIterativeData += newLineCharacter;
		}
		//console.log("csvIterativeData", csvIterativeData);

		// Creating anchor element to download
		let downloadElement = document.createElement('a');

		// This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
		downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvIterativeData);
		downloadElement.target = '_self';
		// CSV File Name
		downloadElement.download = 'Data.csv';
		// below statement is required if you are using firefox browser
		document.body.appendChild(downloadElement);
		// click() Javascript function to download CSV file
		downloadElement.click();
	}

}