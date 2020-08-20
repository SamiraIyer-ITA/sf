/**
 * Created by Skip Kleckner on 5/11/2020.
 */

import {LightningElement, track, api} from 'lwc';
import deleteRecord from '@salesforce/apex/StaffingAssignment.deleteRecord';
import getStaffingAssignmentByParentId from '@salesforce/apex/StaffingAssignment.getStaffingAssignmentByParentId';
import getRecusalLinkMap from '@salesforce/apex/StaffingAssignment.getRecusalLinkMap';
import getSObjectNameFromRecordId from '@salesforce/apex/StaffingAssignment.getSObjectNameFromRecordId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Test from '@salesforce/resourceUrl/Test';

const actions = [
    { label: 'Edit', name: 'edit' },
    { label: 'Delete', name: 'delete' },
];

const staffingAssignmentColumns = [
    {label: 'Title', fieldName: 'Title__c', type: 'pickList', sortable: true},
    {label: 'User', fieldName: 'UserName', Id: 'User__c', type: 'text', sortable: true},
    {label: 'Recusal Link',
        type: 'button-icon',
        fixedWidth: 100,
        typeAttributes: {
            iconName: 'utility:preview',
            name: 'link',
            title: 'Link',
            size:'large',
            variant: 'border-filled',
            alternativeText: { fieldName: 'RecusalLink'},
            disabled: { fieldName: 'RecusalLinkEnable'}
        }
    },
    {
        type: 'action',
        typeAttributes: {
            rowActions: actions,
            disabled: false
        }
    }
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
    @track recusalLinkWrap;
    @track mapkeyvaluestore=[];
    @track spinner = true; //indicates loading
    @track saveSpinner = false;
    @track saveButtonLabel = 'Save';
    @track programManagerCount=0;
    @track programManagerId;

    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;
    caseId;
    sObjectName;
    @track checkfetchRecusalLinkMapCall= true;

    handleCreate() {
        this.saveButtonLabel = 'Save';
        this.showTable = false;
        this.showCreate = true;
    }

    connectedCallback() {
        this.fetchStaffingAssignments();
        this.spinner = true;
        this.getObjectName();

    }

    fetchRecusalLinkMap() {
        getRecusalLinkMap({caseId: this.caseId})
            .then(result => {
                //console.log(JSON.stringify(result));
                this.recusalLinkWrap = result;
                if (result.recusalLinkMap) {
                   
                    var conts = result.recusalLinkMap;
                    for(var key in conts){
                        //console.log(conts[key]);
                        //console.log(key);
                        this.mapkeyvaluestore.push({value:conts[key], key:key}); //Here we are creating the array to show on UI.
                    }
                }

                this.fetchStaffingAssignments();
            })
            .catch(error => {
                
                console.log('error'+error);
            });


    }

    getObjectName(){
        getSObjectNameFromRecordId({recordId: this.recordId})
            .then(result=> {
                console.log(JSON.stringify(result));
                this.sObjectName = result;
            })
    }
    fetchStaffingAssignments() {
        
        this.programManagerCount = 0;

        getStaffingAssignmentByParentId({parentId: this.recordId})
            .then(result => {
                this.data = [];
                console.log(JSON.stringify(result));
                let rows = result;
                let rowBuilder = [];
                for (let i = 0; i < rows.length; i++) {
                    let row = rows[i];
                    //Datatable can't handle related fields, so flatten the data
                    let pair = { RecusalLinkEnable: true };

                    if(row.Title__c == 'Program Manager'){

                        this.programManagerCount = this.programManagerCount+1;
                        this.programManagerId = row.Id;
                    }

                    if (row.User__r) {
                        
                        if (row.User__r.Name) {

                            //Add the User Name to the first level of the row
                            pair = {UserName: row.User__r.Name, RecusalLinkEnable: true};

                            this.mapkeyvaluestore.forEach((rec, idx) =>{
                                    console.log(rec.key); // Now each contact object will have a property called "number"
                                    console.log(rec.value);

                                    if(row.User__c == rec.key){

                                        console.log('call done');

                                        pair = {UserName: row.User__r.Name, RecusalLink: rec.value, RecusalLinkText:'Review Recusals', RecusalLinkEnable: false};
                                        
                                    }
                            });
                            row = {...row, ...pair};
                        }                                
                    }

                    row = {...row, ...pair};

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
                if(this.checkfetchRecusalLinkMapCall){
                 this.checkfetchRecusalLinkMapCall=false;
                    this.fetchRecusalLinkMap();
             }
            })
            .catch(error => {
                this.record = undefined;
                console.log('error'+error);
            });
    }


    handleCancel() {
        this.showTable = true;
        this.showCreate = false;
        this.showUpdate = false;
    }

    handleSuccess() {
        this.saveSpinner = false;
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
    handleError(event) {
        this.saveButtonLabel = 'Save';
        this.saveSpinner = false;
        this.fetchStaffingAssignments();

        let errorMessage = event.detail.detail;
        console.log("response",errorMessage);
        //do some stuff with message to make it more readable
        
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: errorMessage,
                variant: 'error'
            })
        );
    }

    disableButton() {
        this.saveButtonLabel = 'Saving . . .';
        this.saveSpinner = true;
    }

    handleOnSubmitUpdate(event) {
        event.preventDefault();
        // Get data from submitted form
        const fields = event.detail.fields;
        // Here you can execute any logic before submit
        // and set or modify existing fields
        console.log(this.staffingAssignmentId);
        console.log(this.programManagerCount);
        console.log(this.programManagerId);

        if(fields.Title__c != 'Program Manager' && this.staffingAssignmentId == this.programManagerId && this.programManagerCount == 1){
            let errorMessage = 'At least one Program Manager needs to be assigned to a record.';
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: errorMessage,
                    variant: 'error'
                })
            );
        } else if(fields.Title__c == null || fields.Title__c == ''){
            let errorMessage = 'Please select a title for this user.';
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: errorMessage,
                    variant: 'error'
                })
            );
            this.saveButtonLabel = 'Save';
            this.saveSpinner = false;
        } else {
        // You need to submit the form after modifications
        this.template
            .querySelector('lightning-record-edit-form').submit(fields);
        }    
    }

    handleOnSubmitCreate(event) {
        this.saveSpinner = true;
        event.preventDefault();
        // Get data from submitted form
        const fields = event.detail.fields;
        // Here you can execute any logic before submit
        // and set or modify existing fields

        if(fields.Title__c == null || fields.Title__c == '' ){
            let errorMessage = 'Please select a title for this user.';
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: errorMessage,
                    variant: 'error'
                })
            );
            this.saveButtonLabel = 'Save';
            this.saveSpinner = false;
        } else {

            // You need to submit the form after modifications
            this.template
                .querySelector('lightning-record-edit-form').submit(fields);
        }
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
            case 'link':
                const url = row.RecusalLink;
                if(url != undefined){
                    window.open(url, "_blank");
                }
                break;
            default:
                break;
        }
    }

    editRecord(id) {
        this.saveButtonLabel = 'Save';
        this.showUpdate = true;
        this.showTable = false;
        //this.data = [];
        this.staffingAssignmentId = id;
        this.fetchStaffingAssignments();

    }

    handleDelete(recordId) {

        if(this.programManagerId == recordId && this.programManagerCount==1){
            let errorMessage = 'At least one Program Manager needs to be assigned to a record';
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: errorMessage,
                    variant: 'error'
                })
            );
        } else {


            deleteRecord({recordId: recordId})
                .then(() => {
                    this.handleSuccess();
                })
                .catch(error => {
                    let errorMessage = error.body.message;

                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error deleting record',
                            message: errorMessage,
                            variant: 'error'
                        })
                    );
                });
        }
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