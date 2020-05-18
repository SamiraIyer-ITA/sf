import {LightningElement, track} from 'lwc';
import {reduceErrors} from 'c/ldsUtils';
import getTransactions from '@salesforce/apex/Payment2.getTransactions';
import LWCStyles from '@salesforce/resourceUrl/LWCStyles';
import {loadStyle} from 'lightning/platformResourceLoader';
import {createMessageContext,releaseMessageContext, subscribe, APPLICATION_SCOPE} from 'lightning/messageService';
import messageChannel from "@salesforce/messageChannel/TransactionManagement__c";
import getCBSdata from '@salesforce/apex/TransactionManagement.getCBSdata';

const columns = [
	{label: 'Transaction Date', fieldName: 'Transaction_Date__c', type: 'date', typeAttributes:{year: "numeric", month: "long", day: "2-digit", hour: "2-digit", minute: "2-digit"}},
	{label: 'Payment Id', fieldName: 'IdUrl', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
	{label: 'Pay.gov Id', fieldName: 'Remote_Tracking_Id__c', type: 'text'},
	{label: 'Account Holder Name', fieldName: 'Account_Holder_Name__c', type: 'text'},
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
	searchCriteriaObject;  //Object populated from the transactionCriteria LWC
	baseUrl;  //The base Url serving up the page
	subscription = null;
	context = createMessageContext();
	searchCriteria;

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
			//Subscribe to the Lightning Message Service
			this.subscription = subscribe(this.context, messageChannel, (message) => {
				this.handleTransactionListUpdate(message);
			}, {scope: APPLICATION_SCOPE});

			//Get the baseUrl serving up this page
			this.baseUrl = window.location.origin;
		});
	}

	disconnectedCallback() {
		//Release Message Context for Lightning Message Service
		releaseMessageContext(this.context);
	}

	handleTransactionListUpdate(searchCriteria) {
		this.records = undefined;
		this.searchCriteria = searchCriteria;  //Save searchCriteria for refresh after the Download button is pressed
		this.searchCriteriaObject = JSON.parse(searchCriteria.messageBody);
		this.retrievingData = true;

		getTransactions({accountType: this.searchCriteriaObject.accountType, paymentMethod: this.searchCriteriaObject.paymentMethod,
			transactionType: this.searchCriteriaObject.transactionType, fromDateString: this.searchCriteriaObject.fromDate, toDateString: this.searchCriteriaObject.toDate,
			downloaded: this.searchCriteriaObject.downloaded})
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
						//Populate the pair/value needed for showing the amount in red or green
						if (this.searchCriteriaObject.transactionType == "Payments") {
							pair = {"Amount-Color": "color-green"};
						} else {
							//Refunds
							pair = {"Amount-Color": "color-red"};
						}
						row = {...row, ...pair};

						//Populate the pair/value needed for linking the Name field to a Payment record
						pair = {IdUrl: this.baseUrl + "/lightning/r/Payment2__c/" + row.Id + "/view"};
						row = {...row, ...pair};


						rowBuilder.push(row);
						this.selectedRows.push(row.Id);  //Select all Rows by default
						this.selectedTotal += row.Transaction_Amount__c;  //Add up the total amount
					}
					this.tableTitle = this.searchCriteriaObject.downloaded + " " + this.searchCriteriaObject.accountType + " " + this.searchCriteriaObject.paymentMethod + " "
						+ this.searchCriteriaObject.transactionType + " for " + this.searchCriteriaObject.fromDate + " - " + this.searchCriteriaObject.toDate;
					this.records = rowBuilder;
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

	getFormattedDate() {
		let date = new Date().toJSON().slice(0, 16);

		let formattedDate = date.slice(0, 4) +
							date.slice(5, 7) +
							date.slice(8, 10) +
							date.slice(11,13) +
							date.slice(14,16);
		return formattedDate;
	}

	handleToCBS() {
		getCBSdata({paymentIds: this.selectedRows})
			.then(result => {
				if ((! this.isEmpty(result)) && result.csvString) {
					let accountCategory = "";
					let paymentCategory = "";

					switch (this.searchCriteriaObject.accountType) {
						case "Services":
							accountCategory = "SVCS";
							break;
						case "Events":
							accountCategory = "EVNTS";
							break;
						case "Privacy Shield":
							accountCategory = "PS";
							break;
					}

					if (this.searchCriteriaObject.transactionType === "Payments") {
						if (this.searchCriteriaObject.paymentMethod === "Credit Card") {
							paymentCategory = "CC";
						} else {
							//ACH
							paymentCategory = "ACH";
						}
					} else {
						//Refunds
						paymentCategory = "CCR";
					}

					let fileName = "ITA"+accountCategory+"_"+paymentCategory+"_"+this.getFormattedDate()+".txt";
					this.createFile(fileName, result.csvString);

					//Refresh the list
					this.handleTransactionListUpdate(this.searchCriteria);
				} else {
					this.error = "No data available";
				}
			})
			.catch(error => {
				this.error = reduceErrors(error).join(', ');
			});
	}

	handleToExcel() {
		let columnHeader = ["Transaction Date", "Payment Id", "Pay.gov Id", "Amount", "Account Type", "Record Id", "Payment Type", "Account Holder Name", "Account Number"];  // This array holds the Column headers to be displayed
		let jsonKeys = ["Transaction_Date__c", "Name", "Remote_Tracking_Id__c", "Transaction_Amount__c", "Account_Type__c", "Id", "Payment_Type__c", "Account_Holder_Name__c", "Account_Number__c"]; // This array holds the keys in the json data

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
					} else if (this.searchCriteriaObject.transactionType === "Refunds" && dataKey === 'Transaction_Amount__c') {
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

		this.createFile('Data.csv', csvIterativeData);
	}

	createFile(fileName, contents) {
		let downloadElement = document.createElement('a');

		// This  encodeURI encodes special characters, except: , / ? : @ & = + $ # (Use encodeURIComponent() to encode these characters).
		downloadElement.href = 'data:text/plain;charset=utf-8,' + encodeURI(contents);
		downloadElement.target = '_self';
		// CSV File Name
		downloadElement.download = fileName;
		// below statement is required if you are using firefox browser
		document.body.appendChild(downloadElement);
		// click() Javascript function to download file
		downloadElement.click();
	}

}