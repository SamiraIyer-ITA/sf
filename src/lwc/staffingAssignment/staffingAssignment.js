/**
 * Created by Skip Kleckner on 5/11/2020.
 */

import {LightningElement, wire, track, api} from 'lwc';
import deleteRecord from '@salesforce/apex/StaffingAssignment.deleteRecord';
import getStaffingAssignmentByParentId from '@salesforce/apex/StaffingAssignment.getStaffingAssignmentByParentId';
import getSObjectNameFromRecordId from '@salesforce/apex/StaffingAssignment.getSObjectNameFromRecordId';
//import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import {reduceErrors} from 'c/ldsUtils';

const staffingAssignmentColumns = [
    {
        type: 'button-icon',
        fixedWidth: 40,
        typeAttributes: {
            iconName: 'utility:edit',
            name: 'edit',
            title: 'Edit',
            variant: 'bare',
            alternativeText: 'edit',
            disabled: false
        }
    },
    {label: 'Title', fieldName: 'Title__c', type: 'pickList'},
    {label: 'User', fieldName: 'UserName', Id: 'User__c',type: 'text'}
];

export default class StaffingAssignment extends LightningElement {
    @api recordId;  //The parent record Id.

    @track showCreate = false;
    @track showTable = true;
    @track showUpdate = false;
    @track staffingAssignmentId;

    @track datatableStaffingAssignments;
    @track staffingAssignments = [];  //All available staffingAssignments
    @track staffingAssignmentColumns = staffingAssignmentColumns;
    @track error;
    @track gotData = false;
    @track spinner = false;
    @track sortBy;
    @track sortDirection;
    caseId;
    sObjectName;

    get hasNoStaffingAssignments() {
        if (this.gotData) {
            if (this.datatableStaffingAssignments && this.datatableStaffingAssignments.length ==  0) {
                return true;
            }
        }
        return false;
    }

    handleCreate() {
        this.showTable = false;
        this.showCreate = true;
    }

    get hasStaffingAssignments() {
        if (this.gotData) {
            if (this.datatableStaffingAssignments && this.datatableStaffingAssignments.length > 0) {
                return true;
            }
        }
        return false;
    }
    connectedCallback() {
        this.getObjectName();
        this.fetchStaffingAssignments();
    }

    getObjectName(){
        getSObjectNameFromRecordId({recordId: this.recordId})
            .then(result=> {
                console.log(JSON.stringify(result));
                this.sObjectName = result;
            })
    }
    fetchStaffingAssignments() {
        getStaffingAssignmentByParentId({parentId: this.recordId})
            .then(result => {
                console.log(JSON.stringify(result));
                let rows = result;
                let rowBuilder = [];
                for (let i = 0; i < rows.length; i++) {
                    let row = rows[i];
                    //Datatable can't handle related fields, so flatten the data
                    if (row.User__r) {
                        if (row.User__r.Name) {
                            //Add the User Name to the first level of the row
                            let pair = {UserName: row.User__r.Name};
                            row = {...row, ...pair};
                        }
                    }
                    if (row.Petition__r) {
                        if (row.Petition__r.ADCVD_Case__c) {
                            this.caseId = row.Petition__r.ADCVD_Case__c
                        }
                    }
                    if (row.Segment__r) {
                        if (row.Segment__r.ADCVD_Case__c) {
                            this.caseId = row.Segment__r.ADCVD_Case__c
                        }
                    }
                    if (row.ADCVD_Order__r) {
                        if (row.ADCVD_Order__r.ADCVD_Case__c) {
                            this.caseId = row.ADCVD_Order__r.ADCVD_Case__c
                        }
                    }
                    if (row.Investigation__r) {
                        if (row.Investigation__r.ADCVD_Case__c) {
                            this.caseId = row.Investigation__r.ADCVD_Case__c
                        }
                    }
                    rowBuilder.push(row);
                }

                this.datatableStaffingAssignments = rowBuilder;
                this.gotData = true;
                this.error = undefined;
            })
            .catch(error => {
                this.record = undefined;
            });
    }

    handleCancel() {
        this.showTable = true;
        this.showCreate = false;
        this.showUpdate = false;
    }

    handleSuccess() {
        this.showTable = true;
        this.showCreate = false;
        this.showUpdate = false;
        this.fetchStaffingAssignments();
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Staffing Assignment updated',
                variant: 'success'
            })
        );
    }
    handleError() {
        this.fetchStaffingAssignments();
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Staffing Assignment Error',
                variant: 'error'
            })
        );
    }

    handleRowAction(event) {
        var action = event.detail.action;
        var row = event.detail.row;

        switch (action.name) {
            case 'edit':
                this.editRecord(row.Id); // implement this
                break;
            default:
                break;
        }
    }

    editRecord(id) {
        this.showUpdate = true;
        this.showTable = false;
        this.selectedStaffingAssignmentIds = [];
        this.staffingAssignmentId = id;
    }

    handleDelete(event) {
        deleteRecord({recordId: this.staffingAssignmentId})
            .then(() => {
                this.handleSuccess();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    handleSortdata(event) {
        // field name
        this.sortBy = event.detail.fieldName;

        // sort direction
        this.sortDirection = event.detail.sortDirection;

        // calling sortdata function to sort the data based on direction and selected field
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }

    sortData(fieldname, direction) {
        // serialize the data before calling sort function
        let parseData = JSON.parse(JSON.stringify(this.data));

        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };

        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;

        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });

        // set the sorted data to data table data
        this.data = parseData;
    }
}