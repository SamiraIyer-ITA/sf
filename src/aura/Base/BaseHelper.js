({
	isLightningExperience: function() {

		var toast = $A.get("e.force:showToast");
		if (toast){
			return true;
		} else {
			return false;
		}
	},
	showNotification: function(component,header,title,message,variant,closeCallback) {

		if (this.isLightningExperience()) {
			var compEvent = component.getEvent("BaseNotification");

			variant = variant || "info";

			compEvent.setParams({
				type : 'notification',
				config: {
					header: header,
					title: title,
					message: message,
					variant: variant,
					closeCallback: closeCallback
				}
			});
			compEvent.fire();
		}

	},

	showToast: function(title, duration, message,messageTemplate, messageTemplateData, toastType,mode) {

		if (this.isLightningExperience()) {
			var toastEvent = $A.get("e.force:showToast");

			toastType = toastType || "info";
			mode = mode || "sticky";
			message = message || "Unknown message";
			duration = duration || 5000;

			toastEvent.setParams({
				title: title,
				duration: duration,
				message: message,
				messageTemplate: messageTemplate,
				messageTemplateData: messageTemplateData,
				type: toastType,
				mode: mode
			});

			toastEvent.fire();
		}

	},

	handleErrors : function(errors) {

		//Populate the message
		var message = "";

		for(var i=0; i < errors.length; i++) {
			for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
				message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
			}
			if(errors[i].fieldErrors) {
				for(var fieldError in errors[i].fieldErrors) {
					var thisFieldError = errors[i].fieldErrors[fieldError];
					for(var j=0; j < thisFieldError.length; j++) {
						message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
					}
				}
			}
			if(errors[i].message) {
				message += (message.length > 0 ? '\n' : '') + errors[i].message;
			}
		}

		this.showToast("Error", 0, message, null, null, "error","sticky")
	},


	callServer : function(component,method,callback,params) {

		var compEvent = component.getEvent("showSpinner");
		compEvent.fire();


		var action = component.get(method);
		if (params) {
			action.setParams(params);
		}

		action.setCallback(this,function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				// pass returned value to callback function
				callback.call(this,response.getReturnValue());
			} else if (state === "ERROR") {
				// generic error handler
				var errors = response.getError();
				if (errors) {
					console.error("Errors", errors);
					this.handleErrors(errors);
				} else {
					this.handleErrors(new Error("Unknown Error"));
				}
			}
			var compEvent = component.getEvent("hideSpinner");
			compEvent.fire();

		});

		$A.enqueueAction(action);
	},

	hasValidData: function(component, fields) {
		var field = "";
		var returnValue = false;

		for (var i=0; i<fields.length; i++) {
			//console.log("Checking field " + fields[i]);
			field = component.find(fields[i]);
			/*if (!field) {
			   console.log("Unable to find field " + fields[i]);
			}*/
			if (Array.isArray(field)) {
				//console.log("Array of fields.  Array size is " + field.length);
				//If there is more than 1 component using the same aura:id, find() will return an array of them
				for (var x = 0; x<field.length; x++) {
					returnValue = this.checkFieldValidity(field[x]);
					//console.log("Checking validity of " + field[i] + " " + returnValue);
					if (!returnValue) {
						//console.log("Returning false");
						return false;
					}
				}
			} else {
				returnValue = this.checkFieldValidity(field);
				//console.log("Checking validity of " + fields[i] + " " + returnValue);
				if (!returnValue) {
					return false;
				}
			}
		}

		//console.log("Returning true because all fields are valid");

		return true;
	},

	validateRichTextFieldValueAndLength: function(component, fieldName, maxLength) {
		var richTextField = component.find(fieldName);
		/*if (!richTextField) {
			console.log("No value for richTextField");
		}*/

		if (Array.isArray(richTextField)) {
			//If there is more than 1 component using the same aura:id, find() will return an array of them
			for (var x = 0; x<richTextField.length; x++) {
				if (richTextField[x]) {
					var richTextFieldValue = richTextField[x].get("v.value");
					if (!richTextFieldValue || richTextFieldValue.length > maxLength) {
						//Make sure the field has a value and is less than maxLength characters
						richTextField[x].set("v.valid", false);
						return false;
					} else {
						richTextField[x].set("v.valid", true);
					}
				}
			}
			return true;
		} else {
			var richTextFieldValue = richTextField.get("v.value");
			if (!richTextFieldValue || richTextFieldValue.length > maxLength) {
				//Make sure the field has a value and is less than maxLength characters
				richTextField.set("v.valid", false);
				return false;
			} else {
				richTextField.set("v.valid", true);
				return true;
			}
		}

		return false;
	},

	validateOnlyOneHasValue: function(component, fields) {
		var field;
		var fieldValue;
		var oneHasValue = false;

		for (var i=0; i<fields.length; i++) {
			field = component.find(fields[i]);
			if (field) {
				//The field may not be displayed on the screen, so only check for validity if the field can be seen
				if (Array.isArray(field)) {
					//If there is more than 1 component using the same aura:id, find() will return an array of them
					for (var x = 0; x < field.length; x++) {
						if (field[x]) {
							fieldValue = field[x].get("v.value");
							if (fieldValue) {
								if (oneHasValue) {
									return false;  //Too many fields have a value
								}
								oneHasValue = true;
							}
						}
					}
				} else {
					fieldValue = field.get("v.value");
					if (fieldValue) {
						if (oneHasValue) {
							return false;  //Too many fields have a value
						}
						oneHasValue = true;
					}
				}
			}
		}

		return oneHasValue;
	},

	checkFieldValidity: function(field) {
		if (!field) {
			//The field may not be displayed on the screen, so only check for validity if the field can be seen
			//console.log("Field not found");
			return true;
		}
		var validity = field.get("v.validity");
		if (typeof validity == 'object') {
			//console.log(validity);
			var isValid = true;

			if (validity.badInput) {
				field.set('v.validity', {valid:false, badInput :true});
				isValid = false;
			}

			if (validity.patternMismatch) {
				field.set('v.validity', {valid:false, patternMismatch :true});
				isValid = false;
			}

			if (validity.rangeOverflow) {
				field.set('v.validity', {valid:false, rangeOverflow :true});
				isValid = false;
			}

			if (validity.rangeUnderflow) {
				field.set('v.validity', {valid:false, rangeUnderflow :true});
				isValid = false;
			}

			if (validity.stepMismatch) {
				field.set('v.validity', {valid:false, stepMismatch :true});
				isValid = false;
			}

			if (validity.tooLong) {
				field.set('v.validity', {valid:false, tooLong :true});
				isValid = false;
			}

			if (validity.typeMismatch) {
				field.set('v.validity', {valid:false, typeMismatch :true});
				isValid = false;
			}

			if (validity.valueMissing) {
				field.set('v.validity', {valid:false, valueMissing :true});
				isValid = false;
			}

			if (validity.valid) {
				return isValid;
			}

			field.showHelpMessageIfInvalid();

			return false;
		} else {
			return true;
		}

		//console.error("Unable to find Validity");

		return false;
	}

})