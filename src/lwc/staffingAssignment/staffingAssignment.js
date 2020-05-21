/**
 * Created by Skip Kleckner on 5/11/2020.
 */

import {LightningElement, wire, track, api} from 'lwc';
import getStaffingAssignmentByParentId from '@salesforce/apex/StaffingAssignment.getStaffingAssignmentByParentId';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import {reduceErrors} from 'c/ldsUtils';

const staffingAssignmentColumns = [
    {label: 'Title', fieldName: 'Title__c', type: 'pickList'},
    {label: 'User', fieldName: 'UserName', Id: 'User__c',type: 'text',}
];

//{label: 'UserId', fieldName: 'User__c', type: 'sObject'},

export default class StaffingAssignment extends LightningElement {
    @api recordId;  //The Petition record Id.
    @track datatableStaffingAssignments;
    @track staffingAssignments = [];  //All available staffingAssignments
    @track staffingAssignmentColumns = staffingAssignmentColumns;
    @track error;
    @track selectedStaffingAssignmentIds = [];
    @track gotData = false;

    get hasNoStaffingAssignments() {
        if (this.gotData) {
            if (this.datatableStaffingAssignments && this.datatableStaffingAssignments.length ==  0) {
                return true;
            }
        }
        return false;
    }
    get handleSave() {

    }
    get handleCancel() {

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
        this.fetchStaffingAssignments();
    }
    //@wire(getStaffingAssignmentByParentId, {parentId: this.recordId}) staffingAssignmnentList;

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
                    rowBuilder.push(row);
                    //this.datatableStaffingAssignments = [this.datatableStaffingAssignments[0], {Title: }]
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

    handleSuccess() {
        this.resetStaffingSelection();
        this.fetchStaffingAssignments();
    }

    resetStaffingSelection() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Staffing Assignments updated',
                variant: 'success'
            })
        );
        this.selectedStaffingAssignmentIds = [];
    }

    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedStaffingAssignmentIds = [];

        for (let i = 0; i < selectedRows.length; i++) {
            this.selectedStaffingAssignmentIds.push(selectedRows[i].Id);
        }
    }
    get staffingAssignmentSelected() {
        if (this.selectedStaffingAssignmentIds != null && this.selectedStaffingAssignmentIds.length > 0) {
            return true;
        }
        return false;
    }
    get staffingAssignmentId () {
        if (this.selectedStaffingAssignmentIds) {
            return this.selectedStaffingAssignmentIds[0];
        }
    }
}