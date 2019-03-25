@isTest(seeAllData=false)
public class TEST_SectionLightningController{

	static testmethod void TEST_NoSectionNoForm(){
		Form__c myForm = new Form__c();
		insert myForm;
		Form_Section__c mySection = new Form_Section__c(Form__c = myForm.Id);
		insert mySection;
		SectionLightningController controller = new SectionLightningController();
		SectionLightningController.lightningWrapper myLightningWrapper = SectionLightningController.getSectionInfo(null,null);
		System.assertEquals(new Form_Section__c(),myLightningWrapper.myFormSection);
	}

	static testmethod void TEST_NoSection(){
		Form__c myForm = new Form__c();
		insert myForm;
		Form_Section__c mySection = new Form_Section__c(Form__c = myForm.Id);
		insert mySection;
		SectionLightningController controller = new SectionLightningController();
		SectionLightningController.lightningWrapper myLightningWrapper = SectionLightningController.getSectionInfo(null,myForm.Id);
		System.assertEquals(new Form_Section__c(),myLightningWrapper.myFormSection);
	}

	static testmethod void TEST_HasSectionAndForm(){
		Form__c myForm = new Form__c();
		insert myForm;
		Form_Section__c mySection = new Form_Section__c(Form__c = myForm.Id);
		insert mySection;
		SectionLightningController controller = new SectionLightningController();
		SectionLightningController.lightningWrapper myLightningWrapper = SectionLightningController.getSectionInfo(mySection.Id,myForm.Id);
		System.assertEquals(mySection.Id,myLightningWrapper.myFormSection.Id);
	}

	static testmethod void TEST_CreateSection(){
		Form__c myForm = new Form__c();
		insert myForm;
		Form_Section__c mySection = new Form_Section__c(Header__c='header',Form__c=myForm.Id);
		SectionLightningController.newSection(mySection);
		List<Form_Section__c> mySection2 = [select Id from Form_Section__c where Header__c =: 'header'];
	}

	static testmethod void TEST_SaveSection(){
		Form__c myForm = new Form__c();
		insert myForm;
		Form_Section__c mySection = new Form_Section__c(Header__c='header',Form__c = myForm.Id);
		insert mySection;
		mySection.Header__c = 'header2';
		SectionLightningController.saveSection(mySection);
		Form_Section__c mySection2 = [select Header__c from Form_Section__c where Id =: mySection.Id];
		system.assertEquals('header2',mySection2.Header__c);
	}

		static testmethod void TEST_CreateSectionException(){
		Form__c myForm = new Form__c();
		insert myForm;
		Form_Section__c mySection = new Form_Section__c(Header__c='header',Form__c=myForm.Id,Display_Order__c=250);
		SectionLightningController.newSection(mySection);
		List<Form_Section__c> mySection2 = [select Id from Form_Section__c where Header__c =: 'header'];
		system.assertEquals(0,mySection2.size());
	}

	static testmethod void TEST_SaveSectionException(){
		Form__c myForm = new Form__c();
		insert myForm;
		Form_Section__c mySection = new Form_Section__c(Header__c='header',Form__c = myForm.Id);
		insert mySection;
		mySection.Header__c = 'header2';
		mySection.Display_Order__c = 250;
		SectionLightningController.saveSection(mySection);
		Form_Section__c mySection2 = [select Header__c from Form_Section__c where Id =: mySection.Id];
		system.assertNotEquals('header2',mySection2.Header__c);
		system.assertEquals('header',mySection2.Header__c);
	}
}