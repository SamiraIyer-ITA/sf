/**
 * Created by Skip Kleckner on 5/11/2020.
 */

import {LightningElement, track, api} from 'lwc';
import deleteRecord from '@salesforce/apex/StaffingAssignment.deleteRecord';
import getStaffingAssignmentByParentId from '@salesforce/apex/StaffingAssignment.getStaffingAssignmentByParentId';
import getSObjectNameFromRecordId from '@salesforce/apex/StaffingAssignment.getSObjectNameFromRecordId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

const staffingAssignmentColumns = [
    {label: 'Title', fieldName: 'Title__c', type: 'pickList', sortable: true},
    {label: 'User', fieldName: 'UserName', Id: 'User__c', type: 'text', sortable: true},
    {
        type: 'action',
        typeAttributes: {
            rowActions: actions,
            disabled: false
        },
    },

];


export default class StaffingAssignment extends LightningElement {
    @api recordId;  //The parent record Id.

    @track showCreate = false;
    @track showTable = true;
    @track showUpdate = false;
    @track staffingAssignmentId;

    @track data;
    @track staffingAssignments = [];  //All available staffingAssignments
    @track staffingAssignmentColumns = staffingAssignmentColumns;
    @track error;
    @track gotData = false;
    @track spinner = true; //indicates loading
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;
    caseId;
    sObjectName;

    handleCreate() {
        this.showTable = false;
        this.showCreate = true;
    }

    connectedCallback() {
        this.spinner = true;
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
                this.data = [];
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
                            this.caseId = row.Petition__r.ADCVD_Case__c;
                        }
                    }
                    if (row.Segment__r) {
                        if (row.Segment__r.ADCVD_Case__c) {
                            this.caseId = row.Segment__r.ADCVD_Case__c;
                        }
                    }
                    if (row.ADCVD_Order__r) {
                        if (row.ADCVD_Order__r.ADCVD_Case__c) {
                            this.caseId = row.ADCVD_Order__r.ADCVD_Case__c;
                        }
                    }
                    if (row.Investigation__r) {
                        if (row.Investigation__r.ADCVD_Case__c) {
                            this.caseId = row.Investigation__r.ADCVD_Case__c;
                        }
                    }
                    rowBuilder.push(row);
                }
                this.data = rowBuilder;
                this.spinner = false;
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
            case 'delete':
                //this.recordId = row.Id;
                this.handleDelete(row.Id);
                break;
            default:
                break;
        }
    }

    editRecord(id) {
        this.showUpdate = true;
        this.showTable = false;
        //this.data = [];
        this.staffingAssignmentId = id;
        this.fetchStaffingAssignments();

    }

    handleDelete(recordId) {
        deleteRecord({recordId: recordId })
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

    sortBy(field, reverse, primer) {
        const key = primer
            ? function(x) {
                return primer(x[field]);
            }
            : function(x) {
                return x[field];
            };

        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.data];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.data = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }
}