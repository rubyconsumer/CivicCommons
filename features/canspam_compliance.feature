Feature: CANSPAMM Compliance

In order to be compliant with CANSPAM
As a member receiving email
I want to be able to unsubscribe from the daily digest

Scenario: Member missing required information
Given a member who is missing required information
When they unsubscribe from the daily digest
Then they should be unsubscribed from the daily digest


Scenario: Member with all information
Given a member
When they unsubscribe from the daily digest
Then they should be unsubscribed from the daily digest
