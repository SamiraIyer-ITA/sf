import {LightningElement, api} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import gethasPermission from '@salesforce/apex/apo_Modernization.doesRunningUserHavePermission';


export default class apo_Modernization extends LightningElement {
    @api recordId;
    //Declaration of variable, used for checking the permission
    @api isSetupEnabled = false;
    @api isReadView = false;

    //Standard callback method when LWC is loaded 
    connectedCallback() {
        this.isReadView = true;
        this.fetchPermission();
    }

    // Method to check if current user has permission
    fetchPermission() {
        gethasPermission()
            .then(result => {
                //Assignment  permission check
                this.isSetupEnabled = result;

            })
            .catch(error => {

                console.log('error' + error);
            });

    }

    //Handle method when form is submitted on update
    handleSubmit(event) {
        console.log('onsubmit event recordEditForm' + event.detail.fields);
    }

    //Handle method when form is submitted for Edit
    handleEdit(event) {
        this.isReadView = false;
    }

    //Handle method when form is submitted for Cancel
    handleCancel(event) {
        this.isReadView = true;
    }

    // Success method notification/message after record is saved/updated
    handleSuccess(event) {
        this.isReadView = true;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Record Updated Successfully',
                variant: 'success'
            })
        );
    }

    //  Error method notification/message after record is saved/updated
    handleError(event) {
        let errorMessage = event.detail.detail;
        console.log("response", errorMessage);

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: errorMessage,
                variant: 'error'
            })
        );
    }

}