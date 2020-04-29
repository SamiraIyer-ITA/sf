@IsTest
private class Flow_ObjectNamesFromIdsTest {

	@IsTest
	static void findObjectNamesFromRecordIdPrefixes_Positive(){
		List<String> ids = new List<String>();//
		ids.add('500');
		Flow_ObjectNamesFromIds.RequestVariables flowInputs = new Flow_ObjectNamesFromIds.RequestVariables();
		List<Flow_ObjectNamesFromIds.RequestVariables> flowInputsList = new List<Flow_ObjectNamesFromIds.RequestVariables>();
		flowInputs.ids = ids;
		flowInputsList.add(flowInputs);
		List<String> objectNames = Flow_ObjectNamesFromIds.findObjectNamesFromRecordIdPrefixes(flowInputsList);
		System.assertEquals(objectNames[0],'Case');
	}

	@IsTest
	static void findObjectNamesFromRecordIdPrefixes_Negative(){
		List<String> ids = new List<String>();
		ids.add('500');
		Flow_ObjectNamesFromIds.RequestVariables flowInputs = new Flow_ObjectNamesFromIds.RequestVariables();
		List<Flow_ObjectNamesFromIds.RequestVariables> flowInputsList = new List<Flow_ObjectNamesFromIds.RequestVariables>();
		flowInputs.ids = ids;
		flowInputsList.add(flowInputs);
		List<String> objectNames = Flow_ObjectNamesFromIds.findObjectNamesFromRecordIdPrefixes(flowInputsList);
		System.assertNotEquals(objectNames[0],'Account');
	}

	@IsTest
	static void findObjectNamesFromRecordIdPrefixes_Null(){
		List<Flow_ObjectNamesFromIds.RequestVariables> flowInputsList = new List<Flow_ObjectNamesFromIds.RequestVariables>();
		List<String> objectNames = Flow_ObjectNamesFromIds.findObjectNamesFromRecordIdPrefixes(flowInputsList);
		System.assertEquals(objectNames, null);
	}

	@IsTest
	static void findObjectNamesFromRecordIdPrefixes_Empty(){
		List<String> ids = new List<String>();
		ids.add('101');
		Flow_ObjectNamesFromIds.RequestVariables flowInputs = new Flow_ObjectNamesFromIds.RequestVariables();
		List<Flow_ObjectNamesFromIds.RequestVariables> flowInputsList = new List<Flow_ObjectNamesFromIds.RequestVariables>();
		flowInputs.ids = ids;
		flowInputsList.add(flowInputs);
		List<String> objectNames = Flow_ObjectNamesFromIds.findObjectNamesFromRecordIdPrefixes(flowInputsList);
		System.assertEquals(objectNames[0],'');
	}

	@IsTest
	static void findObjectNamesFromRecordIdPrefixes_Exception(){
		List<String> ids = new List<String>();
		ids.add('10');
		Flow_ObjectNamesFromIds.RequestVariables flowInputs = new Flow_ObjectNamesFromIds.RequestVariables();
		List<Flow_ObjectNamesFromIds.RequestVariables> flowInputsList = new List<Flow_ObjectNamesFromIds.RequestVariables>();
		flowInputs.ids = ids;
		flowInputsList.add(flowInputs);
		List<String> objectNames = Flow_ObjectNamesFromIds.findObjectNamesFromRecordIdPrefixes(flowInputsList);
		System.assertEquals(objectNames[0],'');
	}
}