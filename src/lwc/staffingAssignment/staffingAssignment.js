/**
 * Created by Skip Kleckner on 5/11/2020.
 */

import {LightningElement, wire, track, api} from 'lwc';
import getStaffingAssignmentByParentId from '@salesforce/apex/StaffingAssignment.getStaffingAssignmentByParentId';
import getSObjectNameFromRecordId from '@salesforce/apex/StaffingAssignment.getSObjectNameFromRecordId';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import {reduceErrors} from 'c/ldsUtils';

const staffingAssignmentColumns = [
    {label: 'Title', fieldName: 'Title__c', type: 'pickList'},
    {label: 'User', fieldName: 'UserName', Id: 'User__c',type: 'text'}
];

export default class StaffingAssignment extends LightningElement {
    @api recordId;  //The Petition record Id.
    @track createStaffing = false;
    @track showTable = true;
    @track datatableStaffingAssignments;
    @track staffingAssignments = [];  //All available staffingAssignments
    @track staffingAssignmentColumns = staffingAssignmentColumns;
    @track error;
    @track selectedStaffingAssignmentIds = [];
    @track gotData = false;
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
        this.createStaffing = true;
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
                    rowBuilder.push(row);
                }

                this.datatableStaffingAssignments = rowBuilder;
                this.gotData = true;
                this.error = undefined;
            })
            .catch(error => {
                //this.error = reduceErrors(error).join(', ');
                this.record = undefined;
            });
    }
    handleCancel() {
        this.showTable = true;
        this.createStaffing = false;
        this.resetStaffingSelection();
    }
    handleSuccess() {
        this.showTable = true;
        this.createStaffing = false;
        this.resetStaffingSelection();
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
        this.resetStaffingSelection();
        this.fetchStaffingAssignments();
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Staffing Assignment Error',
                variant: 'error'
            })
        );
    }

    resetStaffingSelection() {
        this.selectedStaffingAssignmentIds = [];
    }

    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedStaffingAssignmentIds = [];
        this.showTable = false;

        for (let i = 0; i < selectedRows.length; i++) {
            this.selectedStaffingAssignmentIds.push(selectedRows[i].Id);
        }
    }
    get staffingAssignmentSelected() {
        if (this.selectedStaffingAssignmentIds != null && this.selectedStaffingAssignmentIds.length > 0) {
            return true;
            //this.showTable = false;
        }
        //this.showTable = true;
        return false;
    }
    get staffingAssignmentId () {
        if (this.selectedStaffingAssignmentIds) {
            return this.selectedStaffingAssignmentIds[0];
        }
    }
}