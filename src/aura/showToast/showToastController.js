/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * Licensed under the BSD 3-Clause license.
 * For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
 */

({
    invoke : function(component, event, helper) {
    var args = event.getParam("arguments");
    
    var type = component.get("v.type");
    var title = component.get("v.title");
    var message = component.get("v.message");
    var key = component.get("v.key");
    var mode = component.get("v.mode");
    var duration = component.get("v.duration")+"000";
        
        helper.showToast(type, title, message, key, mode, duration );

    }
})