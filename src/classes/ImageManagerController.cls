public with sharing class ImageManagerController {

    @AuraEnabled
    public Id documentId {get; private set;}

    @AuraEnabled
    public Id imageId {get; private set;}

    @AuraEnabled
    public static ImageManagerController saveChunk(String fileName, String imageName, String imageAltText, String base64Data, String contentType, String documentId) {
        // Note that fileId will always be blank in the first chunk.
        try {
            if (documentId == '') {
                documentId = saveTheFile(imageAltText, imageName, fileName, base64Data, contentType);
            } else {
                appendToFile(documentId, base64Data);
            }

            //Create the return value
            ImageManagerController imageManagerController = new ImageManagerController();
            imageManagerController.documentId = Id.valueOf(documentId);
            imageManagerController.imageId = [SELECT Id FROM Image__c WHERE Location__c = :documentId].Id;

            return imageManagerController;
        } catch (Exception e) {
            throw new AuraHandledException('Error saving file ' + fileName + ' to the Public Images folder: ' + e.getMessage());
        }
    }

    public static Id saveTheFile(String imageAltText, String imageName, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');

        //Note that fileName (e.g. myImage.jpg) is not stored

        Document doc = new Document();
        doc.FolderId = [SELECT Id FROM Folder WHERE Name = 'Public Images' LIMIT 1].Id;
        doc.Body = EncodingUtil.base64Decode(base64Data);
        doc.Name = imageName;
        doc.DeveloperName = imageName.replace(' ', '_');
        doc.ContentType = contentType;  //MIME Type
        doc.IsPublic = true;
        doc.Description = imageAltText;
        insert doc;

        Image__c image = new Image__c();
        image.Name = imageName;
        image.Type__c = 'Background Image';  //Background Image is the only type allowed now
        image.Location__c = doc.id;
        image.Alt__c = imageAltText;
        insert image;

        return doc.Id;
    }

    private static void appendToFile(Id documentId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');

        Document doc = [
            SELECT Id, Body
            FROM Document
            WHERE Id = :documentId
        ];

        String existingBody = EncodingUtil.base64Encode(doc.Body);

        doc.Body = EncodingUtil.base64Decode(existingBody + base64Data);

        update doc;
    }

}