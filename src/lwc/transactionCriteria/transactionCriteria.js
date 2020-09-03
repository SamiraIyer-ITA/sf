import {LightningElement, track, wire} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {fireEvent} from 'c/pubsub';

export default class TransactionCriteria extends LightningElement {

	@wire(CurrentPageReference) pageRef;

	accountTypeOptions = [
		{ label: 'Services', value: 'Services' },
		{ label: 'Events', value: 'Events' },
		{ label: 'Privacy Shield', value: 'Privacy Shield' }
	];

	transactionTypeOptions = [
		{ label: 'Payment', value: 'Payment' },
		{ label: 'Refund', value: 'Refund' }
	];

	paymentMethodOptions = [
		{ label: 'Credit Card', value: 'Credit Card' },
		{ label: 'ACH', value: 'ACH' }
	];

	@track fromDate;
	@track toDate;
	fromDateText;
	toDateText;
	@track accountType;
	@track transactionType;
	@track paymentMethod;
	@track activeAccordionSection = "accountTypeSection";
	firstTimeDateSelection = true;
	firstTimeRefundSelection = true;

	connectedCallback() {
		let d = new Date();
		this.toDate = d.getFullYear() + "-" + ("0" + (d.getMonth() + 1)).slice(-2) + "-" + d.getDate();
		this.toDateText = this.getDateFormatted(this.toDate);
		d.setDate(d.getDate() - 1);
		this.fromDate = d.getFullYear() + "-" + ("0" + (d.getMonth() + 1)).slice(-2) + "-" + d.getDate();
		this.fromDateText = this.getDateFormatted(this.fromDate);
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

	get isRefund() {
		if (this.transactionType == "Refund") {
			return true;
		}
		return false;
	}

	handleTransactionTypeChange(event) {
		this.transactionType = event.detail.value;
		if (this.transactionType == "Refund") {
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
			//return "Date Range: " + this.getDateFormatted(this.fromDate) + " - " + this.getDateFormatted(this.toDate);
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
		let searchCriteria = JSON.stringify(obj);

		fireEvent(this.pageRef, 'transactionListUpdate', searchCriteria);
	}
}