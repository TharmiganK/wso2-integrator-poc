import ballerinax/hubspot.crm.obj.contacts as contacts;

function mapToContactRow(contacts:SimplePublicObjectWithAssociations hubspotContact) returns ContactRow => {
    hubspotId: hubspotContact.id,
    email: hubspotContact.properties["email"],
    firstName: hubspotContact.properties["firstname"],
    lastName: hubspotContact.properties["lastname"],
    phone: hubspotContact.properties["phone"]
};
