/**
 * Created by Skip Kleckner on 5/11/2020.
 */

import {LightningElement, wire, track, api} from 'lwc';
import getStaffingAssignmentByParentId from '@salesforce/apex/StaffingAssignment.getStaffingAssignmentByParentId';
import getRecusalLinkMap from '@salesforce/apex/StaffingAssignment.getRecusalLinkMap';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import {reduceErrors} from 'c/ldsUtils';

const staffingAssignmentColumns = [
    {label: 'Title', fieldName: 'Title__c', type: 'pickList'},
    {label: 'User', fieldName: 'UserName', Id: 'User__c',type: 'text'},
    /*{label: 'Recusal Link', fieldName: 'RecusalLink', type: 'url', 
    typeAttributes: {label: { fieldName: 'RecusalLinkText'}, target: '_blank'}},*/
    {label: 'Recusal Link',type: 'button-icon',
                    fixedWidth: 100,
                    typeAttributes: {
                        iconName: 'action:preview',
                        name: 'Link', 
                        title: 'Link',
                        size:'large',
                        variant: 'brand',
                        alternativeText: { fieldName: 'RecusalLink'},
                        disabled: { fieldName: 'RecusalLinkEnable'}
            }
    }  
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
    @track recusalLinkWrap;
    @track mapkeyvaluestore=[];

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
        
        this.fetchRecusalLinkMap();
        
    }
    //@wire(getStaffingAssignmentByParentId, {parentId: this.recordId}) staffingAssignmnentList;

    fetchRecusalLinkMap() {
        getRecusalLinkMap({parentId: this.recordId})
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

    fetchStaffingAssignments() {
        getStaffingAssignmentByParentId({parentId: this.recordId})
            .then(result => {
                console.log(JSON.stringify(result));
                let rows = result;
                let rowBuilder = [];
                for (let i = 0; i < rows.length; i++) {
                    let row = rows[i];
                    //Datatable can't handle related fields, so flatten the data
                    let pair = {RecusalLinkEnable:true};

                    if (row.User__r) {
                        
                        if (row.User__r.Name) {

                            //Add the User Name to the first level of the row
                            pair = {UserName: row.User__r.Name,RecusalLinkEnable:true};
                            

                            this.mapkeyvaluestore.forEach((rec, idx) =>{
                                    console.log(rec.key); // Now each contact object will have a property called "number"
                                    console.log(rec.value);
                                    
                                    if(row.User__c==rec.key){
                                        console.log('call done');
                                        pair = {UserName: row.User__r.Name,RecusalLink:rec.value,RecusalLinkText:'Review Recusals',RecusalLinkEnable:false};
                                        
                                    }
                                        
                            });

                            
                        
                        }        
                         //console.log(this.recusalLinkWrap.recusalStatusMap[key]);
                        

                    }
                    row = {...row, ...pair};
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
                console.log('error'+error);
            });
    }

    callRowAction( event ) {  
          
        const recId =  event.detail.row.Id;  
        const actionName = event.detail.action.name;
        
        if(actionName == 'Link'){
            const url = event.detail.row.RecusalLink;
        
            if(url != undefined){

                window.open(url, "_blank");
            }

        }
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