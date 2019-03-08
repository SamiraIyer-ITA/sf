({
    MAX_FILE_SIZE: 4900000, //Max Document size is 5 MB.  Set the image limit to 4.9 MB to accommodate.
    CHUNK_SIZE: 750000,     //Chunk Max size 750Kb (it must be less than 1 MB)

    uploadHelper: function(cmp, event) {
        // start/show the loading spinner
        var compEvent = cmp.getEvent("showSpinner");
        compEvent.fire();
        // get the selected files using aura:id [return array of files]
        var fileInput = cmp.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;  //Calling uploadProcess() will not work without doing this.
        // Check the selected file size.  If it's greater than the MAX_FILE_SIZE, then show a alert message
        if (file.size > self.MAX_FILE_SIZE) {
            var compEvent = cmp.getEvent("hideSpinner");
            compEvent.fire();
            self.showToast("Error", 0, "File size cannot exceed " + self.MAX_FILE_SIZE + " bytes." + " The selected file size is: " + file.size + " bytes.", null, null, "error","sticky");
            return;
        }

        // Create a FileReader object
        var objFileReader = new FileReader();
        // Set the onload function of the FileReader object
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;

            fileContents = fileContents.substring(dataStart);
            // Call the uploadProcess method
            self.uploadProcess(cmp, file, fileContents);
        });

        objFileReader.readAsDataURL(file);
    },

    uploadProcess: function(cmp, file, fileContents) {
        // Set a default size or start position of 0
        var startPosition = 0;
        // Calculate the end size or end position using Math.min() function
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);

        // Start with the initial chunk.  attachId (the last parameter) is null to begin
        this.uploadInChunk(cmp, file, fileContents, startPosition, endPosition, '');
    },


    uploadInChunk: function(cmp, file, fileContents, startPosition, endPosition, documentId) {
        // call the apex method 'saveChunk'
        var getChunk = fileContents.substring(startPosition, endPosition);
        var action = cmp.get("c.saveChunk");
        action.setParams({
            imageAltText: cmp.get("v.imageAltText"),
            fileName: file.name,
            imageName: cmp.get("v.imageName"),
            base64Data: encodeURIComponent(getChunk),
            contentType: file.type,
            documentId: documentId
        });

        // set call back 
        action.setCallback(this, function(response) {
            // The response is an instance of ImageManagerController
            documentId = response.getReturnValue().documentId;
            var state = response.getState();
            if (state === "SUCCESS") {
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // Check if the start position is still less than the end position.
                // If so, call uploadInChunk() again.  Otherwise, display the error.
                if (startPosition < endPosition) {
                    this.uploadInChunk(cmp, file, fileContents, startPosition, endPosition, documentId);
                } else {
                    var compEvent = cmp.getEvent("hideSpinner");
                    compEvent.fire();
                    var showImage = cmp.get("v.showImage");
                    if (showImage) {
                        //Redirect to the image page
                        var sobjectEvent = $A.get("e.force:navigateToSObject");
                        sobjectEvent.setParams({
                            "recordId": response.getReturnValue().imageId
                        });
                        sobjectEvent.fire();
                    } else {
                        //Clear the file and fields
                        cmp.set("v.imageName", "");
                        cmp.set("v.imageAltText", "");
                        cmp.find("imagePreviewId").getElement().src = "";
                        cmp.set("v.fileName", "No File Selected");
                    }
                    this.showToast("File Save", 3000, "Your file has been successfully uploaded.", null, null, "success", "dismissible");
                }
            } else if (state === "INCOMPLETE") {
                this.showToast("Server Error", 0, "File upload incomplete.", null, null, "error","sticky");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast("Server Error", 0, errors[0].message, null, null, "error","sticky");
                    }
                } else {
                    this.showToast("Server Error", 0, "Unknown error", null, null, "error","sticky");
                }
            }
        });

        $A.enqueueAction(action);
    },

    checkPageContentValidity: function (cmp, event) {
        var fields = ["imageName", "imageAltText"];
        return this.hasValidData(cmp, fields);
    },

    handleUpload: function(cmp, event, helper) {
        if (helper.checkPageContentValidity(cmp, event)) {
            if (cmp.find("fileId").get("v.files").length > 0) {
                helper.uploadHelper(cmp, event);
            } else {
                this.showToast("Error", 0, "Please select a valid file.", null, null, "error", "sticky");
            }
        } else {
            helper.showToast("Error", 0, "Please correct the invalid data.", null, null, "error", "sticky");
        }
    },
})