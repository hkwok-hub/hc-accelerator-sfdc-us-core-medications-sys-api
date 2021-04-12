# hc-accelerator-sfdc-us-core-medication-sys-api

_This implementation template is part of the Healthcare Accelerator_

## Overview

This asset provides a framework for implementation of a FHIR
medication system API. It is part of the Patient Access API.

# Setup guide

Please review the [pre-requisite setup instructions](https://anypoint.mulesoft.com/exchange/dfb8ffc8-d878-4ae3-a4ad-7d2c4424f95a/accelerator-for-healthcare/minor/1.0/pages/Setup%20instructions/) for setting up Salesforce Health Cloud, Salesforce Connected App, and MuleSoft's HL7 Connector.

## Importing Templates into Anypoint Studio

 1. In Studio, click the Exchange **X** icon in the upper left of the taskbar.
 2. Log in with your Anypoint Platform credentials.
 3. Search for the template
 4. Click **Open**.<br><br>
 
## Running Templates in Anypoint Studio

After you import your template into Studio, follow these configuration steps to run it:

 1. Right-click the template project folder.
 2. Hover your mouse over 'Run as'.
 3. Click **Mule Application** (configure).
 4. Inside the dialog, select Environment and set the variable:
   * `mule.env` to the appropriate value (e.g., dev or local).
   * `mule.key` to the property encryption key that you used to encrypt your secure properties.
 6. Click **Run**.<br><br>
 
## HTTP Configuration

* `http.host` — sets the service host interface. It should be configured in `config-<mule.env>.yaml` file. (Defaults to 0.0.0.0 for all interfaces)
* `http.port` — sets the service port number. It should be configured in `config-<mule.env>.yaml` file. (Default 8081)<br><br>


## Testing it

- Use [Advanced Rest Client](https://install.advancedrestclient.com/install) or [Postman](https://www.postman.com/) to send a request over HTTP. The template includes a postman collection in the `src/test/resources` folder.


# Field mapping

#### HealthCloudGA__EhrMedication__c
See src/main/resources/dw/FHIRTools.dwl for a mapping example.

| FHIR Field | Field | Notes |
| ----------- | ----------- | ----------- |
| resourceType |  | "Medication"|
| id | Id | |
| Identifier[0].system | HealthCloudGA__SourceSystem__c | |
| Identifier[0].display | HealthCloudGA__SourceSystemId__c | |
| Identifier[0].value | Name | |
| Identifier[0].assigner | HealthCloudGA__Account__c | |
| code.coding.system | HealthCloudGA__MedicationCodeSystem__c | |
| code.coding.code | HealthCloudGA__MedicationCode__c  | |
| code.coding.display | HealthCloudGA__MedicationCodeLabel__c | |
| code.coding.text | HealthCloudGA__MedicationCodeLabel__c | |
| status | Actively_Taking__c | |
| form.coding.system | HealthCloudGA__MedicationCodeSystem__c | |
| form.coding.code | HealthCloudGA__MedicationCode__c  | |
| form.coding.display | HealthCloudGA__MedicationCodeLabel__c | |
| form.coding.text | HealthCloudGA__MedicationCodeLabel__c | |
| amount.numerator | Filled_Quantity__c | |
| ingredient.itemCodeableConcept.coding.system | HealthCloudGA__MedicationKindSystem__c | |
| ingredient.itemCodeableConcept.coding.code | HealthCloudGA__MedicationKindCode__c  | |
| ingredient.itemCodeableConcept.coding.display | HealthCloudGA__MedicationKindLabel__c | |
| ingredient.itemCodeableConcept.coding.text | HealthCloudGA__MedicationKindLabel__c | |
| batch.lotNumber | HealthCloudGA__MedicationLotNumber__c | |
| batch.expirationDate | HealthCloudGA__MedicationExpiration__c | |
