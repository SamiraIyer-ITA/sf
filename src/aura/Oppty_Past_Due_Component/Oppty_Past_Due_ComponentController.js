({
    doInit: function (component, event, helper) {
        helper.checkStatus(component, event);
    },

    recordUpdated: function (component, event, helper) {
        var changeType = event.getParams().changeType;

        if (changeType === 'ERROR') {
            /* handle error; do this first! */
        } else if (changeType === 'CHANGED') {
            helper.checkStatus(component, event); /* handle record change */
        }
    }
});
