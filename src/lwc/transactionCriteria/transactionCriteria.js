import {LightningElement, track} from 'lwc';
import {publish,createMessageContext,releaseMessageContext} from 'lightning/messageService';
import messageChannel from "@salesforce/messageChannel/TransactionManagement__c";

export default class TransactionCriteria extends LightningElement {

	accountTypeOptions = [
		{ label: 'Services', value: 'Services' },
		{ label: 'Events', value: 'Events' },
		{ label: 'Privacy Shield', value: 'Privacy Shield' }
	];

	transactionTypeOptions = [
		{ label: 'Payments', value: 'Payments' },
		{ label: 'Refunds', value: 'Refunds' }
	];

	paymentMethodOptions = [
		{ label: 'Credit Card', value: 'Credit Card' },
		{ label: 'ACH', value: 'ACH' }
	];

	downloadedOptions = [
		{ label: 'Not Yet Downloaded', value: 'Not Yet Downloaded' },
		{ label: 'All', value: 'All' }
	];

	@track fromDate;
	@track toDate;
	fromDateText;
	toDateText;
	@track accountType;
	@track transactionType;
	@track paymentMethod;
	@track downloaded = "Not Yet Downloaded";
	@track activeAccordionSection = "accountTypeSection";
	firstTimeDateSelection = true;
	firstTimeRefundSelection = true;
	context = createMessageContext();

	connectedCallback() {
		let d = new Date();
		this.toDate = d.getFullYear() + "-" + ("0" + (d.getMonth() + 1)).slice(-2) + "-" + d.getDate();
		this.toDateText = this.getDateFormatted(this.toDate);
		d.setDate(d.getDate() - 1);
		this.fromDate = d.getFullYear() + "-" + ("0" + (d.getMonth() + 1)).slice(-2) + "-" + d.getDate();
		this.fromDateText = this.getDateFormatted(this.fromDate);
	}

	disconnectedCallback() {
		//Release Message Context for Lightning Message Service
		releaseMessageContext(this.context);
	}

	get accountTypeText() {
		if (this.accountType) {
			return "Account Type: " + this.accountType;
		}
		return "Account Type";
	}

	handleAccountTypeChange(event) {
		this.accountType = event.detail.value;
		if (! this.transactionType) {
			this.activeAccordionSection = "transactionTypeSection";
		}
	}

	get transactionTypeText() {
		if (this.transactionType) {
			return "Transaction Type: " + this.transactionType;
		}
		return "Transaction Type";
	}

	get downloadedText() {
		if (this.downloaded) {
			return "Transactions to Display: " + this.downloaded;
		}
		return "Transactions to Display";
	}

	get isRefund() {
		if (this.transactionType == "Refunds") {
			return true;
		}
		return false;
	}

	handleTransactionTypeChange(event) {
		this.transactionType = event.detail.value;
		if (this.transactionType == "Refunds") {
			this.paymentMethod = "Credit Card";
			if (this.firstTimeRefundSelection == true) {
				this.activeAccordionSection = "dateRangeSection";
				this.firstTimeRefundSelection = false;
			}
		}
		if (! this.paymentMethod) {
			this.activeAccordionSection = "paymentMethodSection";
		}
	}

	get paymentMethodText() {
		if (this.paymentMethod) {
			return "Payment Method: " + this.paymentMethod;
		}
		return "Payment Method";
	}

	handlePaymentMethodChange(event) {
		this.paymentMethod = event.detail.value;
		if (this.firstTimeDateSelection == true) {
			this.activeAccordionSection = "dateRangeSection";
			this.firstTimeDateSelection = false;
		}
	}

	get dateRangeText() {
		if (this.fromDateText && this.toDateText) {
			return "Date Range: " + this.fromDateText + " - " + this.toDateText;
		}
		return "Date Range";
	}

	handleToDateRangeChange(event) {
		this.toDate = event.detail.value;
		this.toDateText = this.getDateFormatted(this.toDate);
	}

	handleFromDateRangeChange(event) {
		this.fromDate = event.detail.value;
		this.fromDateText = this.getDateFormatted(this.fromDate);
	}

	getDateFormatted(d) {
		let s = d.split("-");
		return [("0" + (s[1])).slice(-2), ("0" + s[2]).slice(-2), s[0]].join("/");
	}

	handleSearchClick() {
		let obj = new Object();
		obj.accountType = this.accountType;
		obj.transactionType  = this.transactionType;
		obj.paymentMethod = this.paymentMethod;
		obj.fromDate = this.fromDateText;
		obj.toDate = this.toDateText;
		obj.downloaded = this.downloaded;
		let searchCriteria = JSON.stringify(obj);

		//Send the search criteria to the transactionList LWC
		const payload = {
			source: "transactionCriteria",
			messageBody: searchCriteria
		};
		publish(this.context, messageChannel, payload);

	}

	handleDownloadedChange(event) {
		this.downloaded = event.detail.value;
	}
}