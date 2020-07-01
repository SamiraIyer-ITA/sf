import {LightningElement, track, api} from 'lwc';
import getOrdersByContractId from '@salesforce/apex/Payment2.getOrdersByContractId';
import {reduceErrors} from 'c/ldsUtils';

const orderColumns = [
	{label: 'Order Name', fieldName: 'Name', type: 'text'},
	{label: 'Amount', fieldName: 'TotalAmount', type: 'currency', typeAttributes: { currencyCode: 'USD'}},
	{label: 'Product', fieldName: 'Type', type: 'text'},
	{label: 'Contract Number', fieldName: 'ContractNumber', type: 'text'},
	{label: 'Contract Name', fieldName: 'ContractName', type: 'text'}
];

export default class PaymentOrderList extends LightningElement {

	@api recordId;  //The Contract record Id.
	@track orders;
	@track orderColumns = orderColumns;
	@track error;
	@track paymentTotal = 0;
	@track selectedOrders = [];
	productType;
	@track gotData = false;

	get hasNoOrders() {
		if (this.gotData) {
			if (this.orders && this.orders.length ==  0) {
				return true;
			}
		}
		return false;
	}

	get hasOrders() {
		if (this.gotData) {
			if (this.orders && this.orders.length > 1) {
				return true;
			}
		}
		return false;
	}

	connectedCallback() {
		getOrdersByContractId({contractId: this.recordId, normalOrders: true, reductionOrders: false, nonPaidOnly: true, paidOnly: false})
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
					this.selectedOrders.push(row.Id);
					this.paymentTotal += row.TotalAmount;
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

				this.orders = rowBuilder;
				this.gotData = true;
				this.error = undefined;

				//If there is only 1 order, then just pay for it
				if (this.orders.length == 1) {
					this.productType = this.orders[0].Type;
					this.handlePay();
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
		this.selectedOrders = [];

		if (selectedRows.length == 0) {
			this.productType = undefined;
			return;
		}

		for (let i = 0; i < selectedRows.length; i++) {
			if (i == 0) {
				this.productType = selectedRows[i].Type;  //Only necessary to populate this once each time
			}
			this.selectedOrders.push(selectedRows[i].Id);
			this.paymentTotal += selectedRows[i].TotalAmount;
		}

	}

	handleCancel() {
		//Tell parent to remove this component
		this.dispatchEvent(new CustomEvent('cancel'));
	}

	handlePay() {
		this.dispatchEvent(new CustomEvent('ordersselected', {
			detail: {selectedOrders: this.selectedOrders, productType: this.productType}
		}));
	}

	get hasTotal() {
		return this.paymentTotal > 0;
	}

}