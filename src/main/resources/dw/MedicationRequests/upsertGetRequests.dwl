/**
 * This module defines functions needed to convert a 
 * FHIR Encounter resource into it's representation within 
 * Health Cloud.
 */
%dw 2.0

 
/**
 * Converts the provided Encounter FHIR object 
 * to the HealthCloud Encounter object.
 * @param fhirObj is a FHIR Encounter object.
 * @param codeSetBundleList is the list of 
 * CodeSetBundle objects for the Encounter
 * object
 * @return HealthCloud Encounter upsert fields.
 */
fun getMedicationUpsert(fhirObj, codeSetBundleList, quantityUnitId) = {
        "Status": fhirObj.status,
        "ManufacturerId": 
        (if (!isEmpty(fhirObj.manufacturer.reference))
        	(fhirObj.manufacturer.reference splitBy("/"))[-1]
        else null),
		"MedicationCodeId": ((codeSetBundleList.allCodeBundleSet filter($.BundleType == "CODE")).Id)[0],
		"MedicationFormId": ((codeSetBundleList.allCodeBundleSet filter($.BundleType == "FORM")).Id)[0],
		"QuantityDenominator": fhirObj.amount.denominator.value,
		"QuantityNumerator": fhirObj.amount.numerator.value,
		"QuantityUnitId": quantityUnitId,
		"Name": "Medication"
		}




/**
 * Converts the provided Encounter FHIR object 
 * to the HealthCloud CodeSet object.
 * @param codeSetList is the list of codeSet object.
 * @return HealthCloud CodeSet upsert fields.
 */
fun getCodeSetUpsert(codeSetList) = {
        "Code": codeSetList.Code,
		"SourceSystem": codeSetList.SourceSystem,
		"CodeDescription": codeSetList.CodeDescription,		
		"SystemVersion": codeSetList.SystemVersion,
		"Name": codeSetList.CodeDescription,			
}

/**
 * Converts the provided Encounter FHIR object 
 * to the HealthCloud CodeSetBundle object.
 * @param codeSetList is the list of CodeSetBundle object.
 * @param bundleType is for defining the CodeSetBundle type.
 * @param bundleType is for defining the name of the CodeSetBundle.
 * @return HealthCloud CodeSetBundle upsert fields.
 */
fun getCodeSetBundleUpsert(codeSetList, bundleType , name) = {	
 		(if (!isEmpty((codeSetList  default [] filter ($.BundleType == bundleType)).BundleText)) 		
 			Name: (codeSetList  default [] filter ($.BundleType == bundleType)).BundleText reduce $
 			
 		else 
 			Name: name
 		),
 	
 	
 		(codeSetList  default [] filter ($.BundleType == bundleType)  map (cs, csIndex) -> using (csId = "CodeSet" ++ (csIndex + 1) ++ "Id")
 			{
 				
 			(csId): cs.Id
 			
 			}
 		)

}

/**
 * Converts the provided Encounter FHIR object 
 * to the HealthCloud ClinicalEncounterIdentifier object.
 * @param identifier is the list of ClinicalEncounterIdentifier object.
 * @param encounterId is the associated encounter Id
 * @return HealthCloud ClinicalEncounterIdentifier upsert fields.
 */
fun getIdentifierUpsert(identifier, encounterId, typeId) = {
        "IdUsageType": identifier.use,
        "IdValue": identifier.value,
        "SourceSystem": identifier.system,	
        "IdTypeId": typeId,
       // "Name": "Encounter Identifier",
        "ClinicalEncounterId":	encounterId
}

