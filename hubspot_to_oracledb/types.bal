// Oracle DB row representation of a synchronized HubSpot contact.
public type ContactRow record {|
    string hubspotId;
    string? email;
    string? firstName;
    string? lastName;
    string? phone;
|};
