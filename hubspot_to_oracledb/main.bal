import ballerina/log;
import ballerinax/trigger.hubspot;

listener hubspot:Listener hubspotListener = new ({clientSecret: string `${clientSecret}`, callbackURL: string `${callbackURL}`}, listenOn = 8090);

service hubspot:ContactService on hubspotListener {
    remote function onContactCreation(hubspot:WebhookEvent event) returns error? {
        do {
            log:printInfo("received contact creation event");
            int? objectId = event.objectId;
            if objectId is () {
                log:printWarn("contact creation event missing objectId, skipping");
                return;
            }
            string contactId = objectId.toString();
            log:printInfo("fetching HubSpot contact details", contactId = contactId);
            var contact = check hubspotContacts->/[contactId](
                properties = ["email", "firstname", "lastname", "phone"]
            );
            ContactRow contactRow = mapToContactRow(contact);
            if contactRow.hubspotId == "" {
                log:printWarn("contact returned empty id, skipping", contactId = contactId);
                return;
            }
            log:printInfo("inserting contact into database", contactId = contactId);
            _ = check oracleDb->execute(`
                INSERT INTO HUBSPOT_CONTACTS (HUBSPOT_ID, EMAIL, FIRST_NAME, LAST_NAME, PHONE)
                VALUES (${contactRow.hubspotId}, ${contactRow.email}, ${contactRow.firstName}, ${contactRow.lastName}, ${contactRow.phone})
            `);
            log:printInfo("contact successfully inserted into database", contactId = contactId);
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

    remote function onContactDeletion(hubspot:WebhookEvent event) returns error? {
        do {
            log:printInfo("received contact deletion event");
            int? objectId = event.objectId;
            if objectId is () {
                log:printWarn("contact deletion event missing objectId, skipping");
                return;
            }
            log:printInfo("deleting contact from database", contactId = objectId);
            _ = check oracleDb->execute(`DELETE FROM HUBSPOT_CONTACTS WHERE HUBSPOT_ID = ${objectId}`);
            log:printInfo("contact successfully deleted from database", contactId = objectId);
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

    remote function onContactPropertychange(hubspot:WebhookEvent event) returns error? {
        do {
            log:printInfo("received contact property change event");
            int? objectId = event.objectId;
            if objectId is () {
                log:printWarn("contact property change event missing objectId, skipping");
                return;
            }
            string? propertyName = event.propertyName;
            if propertyName is () {
                log:printWarn("contact property change event missing propertyName, skipping");
                return;
            }
            string? propertyValue = event.propertyValue;
            if propertyValue is () {
                log:printWarn("contact property change event missing propertyValue, skipping");
                return;
            }
            log:printInfo("processing property change", contactId = objectId, propertyName = propertyName);
            match propertyName {
                "email" => {
                    _ = check oracleDb->execute(`UPDATE HUBSPOT_CONTACTS SET EMAIL = ${propertyValue} WHERE HUBSPOT_ID = ${objectId}`);
                    log:printInfo("updated email", contactId = objectId);
                }
                "firstname" => {
                    _ = check oracleDb->execute(`UPDATE HUBSPOT_CONTACTS SET FIRST_NAME = ${propertyValue} WHERE HUBSPOT_ID = ${objectId}`);
                    log:printInfo("updated firstname", contactId = objectId);
                }
                "lastname" => {
                    _ = check oracleDb->execute(`UPDATE HUBSPOT_CONTACTS SET LAST_NAME = ${propertyValue} WHERE HUBSPOT_ID = ${objectId}`);
                    log:printInfo("updated lastname", contactId = objectId);
                }
                "phone" => {
                    _ = check oracleDb->execute(`UPDATE HUBSPOT_CONTACTS SET PHONE = ${propertyValue} WHERE HUBSPOT_ID = ${objectId}`);
                    log:printInfo("updated phone", contactId = objectId);
                }
                _ => {
                    log:printInfo("property is not tracked, skipping", propertyName = propertyName);
                }
            }
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

    remote function onContactAssociationchange(hubspot:WebhookEvent event) returns error? {
        do {
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

    remote function onContactMerge(hubspot:WebhookEvent event) returns error? {
        do {
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

    remote function onContactRestore(hubspot:WebhookEvent event) returns error? {
        do {
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

    remote function onContactPrivacydeletion(hubspot:WebhookEvent event) returns error? {
        do {
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }
}

