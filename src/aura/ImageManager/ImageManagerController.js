({
    handleUploadView: function(cmp, event, helper) {
        cmp.set("v.showImage", true);
        helper.handleUpload(cmp, event, helper);
    },

    handleUploadNew: function(cmp, event, helper) {
        cmp.set("v.showImage", false);
        helper.handleUpload(cmp, event, helper);
    },

    handleFilesChange: function(cmp, event, helper) {
        var fileName = 'No File Selected';
        var file = event.getSource().get("v.files")[0];
        var img = cmp.find("imagePreviewId").getElement();
        if (event.getSource().get("v.files").length > 0) {
            fileName = file['name'];

            //Display the preview
            img.src = URL.createObjectURL(file);
        } else {
            //Hide the preview
            img.src = null;
        }
        //Show the file name
        cmp.set("v.fileName", fileName);
    },


})