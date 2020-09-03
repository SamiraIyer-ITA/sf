import {LightningElement, track, api} from 'lwc';
import getOrdersByContractId from '@salesforce/apex/Payment2.getOrdersByContractId';
import {FlowAttributeChangeEvent} from 'lightning/flowSupport';
import {reduceErrors} from 'c/ldsUtils';

const orderColumns = [
	{label: 'Order Name', fieldName: 'Name', type: 'text'},
	{label: 'Payment Amount', fieldName: 'TotalAmount', type: 'currency', typeAttributes: { currencyCode: 'USD'}, cellAttributes: {alignment: "left"}},
	{label: 'Refunded Amount', fieldName: 'Refunded_Amount__c', type: 'currency', typeAttributes: { currencyCode: 'USD'}, cellAttributes: {alignment: "left"}},
	{label: 'Product', fieldName: 'Type', type: 'text'},
	{label: 'Contract Number', fieldName: 'ContractNumber', type: 'text'},
	{label: 'Contract Name', fieldName: 'ContractName', type: 'text'}
];
export default class OrdersForContract extends LightningElement {

	@api recordId;  //The Contract record Id.
	@api actionType;  //Payment or Refund.  Filters orders by whether should have already been paid.
	@track datatableOrders;
	@track orders = [];  //All available orders
	@api selectedOrders = [];
	@track orderColumns = orderColumns;
	@track error;
	@track paymentTotal = 0;
	@track selectedOrderIds = [];
	productType;
	@track gotData = false;

	@api
	validate() {
		//Tell the flow whether this component is valid or not
		if(this.selectedOrderIds.length >  0) {
			return { isValid: true };
		}
		else {
			return {
				isValid: false,
				errorMessage: 'At least one order must be selected before continuing.'
			};
		}
	}

	get hasNoOrders() {
		if (this.gotData) {
			if (this.datatableOrders && this.datatableOrders.length ==  0) {
				return true;
			}
		}
		return false;
	}

	get hasOrders() {
		if (this.gotData) {
			if (this.datatableOrders && this.datatableOrders.length > 0) {
				return true;
			}
		}
		return false;
	}

	get totalTitle() {
		if (this.actionType == 'Refund') {
			return "Refundable Total";
		}
		return "Payment Total";
	}

	connectedCallback() {
		//Assume that the action if for a Payment
		let paidOnly = false;
		let unpaidOnly = true;
		if (this.actionType == 'Refund') {
			paidOnly = true;
			unpaidOnly = false;
		}
		getOrdersByContractId({contractId: this.recordId, onlyCreditCardPayments: false, nonPaidOnly: unpaidOnly, paidOnly: paidOnly})
			.then(result => {
				let rows = result;
				let rowBuilder = [];
				for (let i = 0; i < rows.length; i++) {
					let row = rows[i];
					//Select all Orders by default
					if (i == 0) {
						//Only necessary to keep track of the product type for the first row,
						//since all rows should have the same product type
						this.productType = row.Type;
					}
					//Datatable can't handle related fields, so flatten the data
					if (row.Contract) {
						if (row.Contract.ContractNumber) {
							//Add the Contract Number to the first level of the row
							let pair = {ContractNumber: row.Contract.ContractNumber};
							row = {...row, ...pair};
						}
						if (row.Contract.Name) {
							//Add the Contract Name to the first level of the row
							let pair = {ContractName: row.Contract.Name};
							row = {...row, ...pair};
						}
					}
					rowBuilder.push(row);
				}

				this.datatableOrders = rowBuilder;
				this.gotData = true;
				this.error = undefined;

				//Flow can't handle Contract or Payment info being in an Order record, so remove it
				this.orders = JSON.parse(JSON.stringify(result));  //This is a workaround because the delete method won't work otherwise
				for (let i=0; i < this.orders.length; i++) {
					if (this.orders[i].Contract) {
						delete this.orders[i].Contract;
					}
					if (this.orders[i].Payment2__r) {
						delete this.orders[i].Payment2__r;
					}
				}

			})
			.catch(error => {
				this.error = reduceErrors(error).join(', ');
				this.record = undefined;
			});
	}

	handleRowSelection(event) {
		const selectedRows = event.detail.selectedRows;

		this.paymentTotal = 0;
		this.selectedOrderIds = [];

		if (selectedRows.length == 0) {
			this.productType = undefined;
			return;
		}

		for (let i = 0; i < selectedRows.length; i++) {
			if (i == 0) {
				this.productType = selectedRows[i].Type;  //Only necessary to populate this once each time
			}
			this.selectedOrderIds.push(selectedRows[i].Id);
			this.paymentTotal += selectedRows[i].TotalAmount - selectedRows[i].Refunded_Amount__c;
		}

		//Notify the Flow of the selectedOrders
		this.notifyFlowOfSelectedOrders();

	}

	notifyFlowOfSelectedOrders() {
		//To the Flow, send the Order object themselves rather than Ids
		this.selectedOrders = [];
		for (let i = 0; i < this.selectedOrderIds.length; i++) {
			for (let x =0; x < this.orders.length; x++) {
				if (this.orders[x].Id === this.selectedOrderIds[i]) {
					this.selectedOrders.push(this.orders[x]);
				}
			}
		}

		const attributeChangeEvent = new FlowAttributeChangeEvent("selectedOrders", this.selectedOrders);
		this.dispatchEvent(attributeChangeEvent);
	}

}