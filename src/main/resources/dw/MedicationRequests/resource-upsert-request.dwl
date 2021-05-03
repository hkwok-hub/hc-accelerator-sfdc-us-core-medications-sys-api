%dw 2.0
output application/json skipNullOn="everywhere"
import getMedicationUpsert, getIdentifierUpsert  from dw::Medication::upsertGetRequests
---
{
	allOrNone: false,
	compositeRequest: 
	flatten(
		[
  			// Medication
			{
				method: "POST",
				referenceId: "Medication",
				url: "/services/data/v51.0/sobjects/Medication",
				body: getMedicationUpsert(vars.medicationRequest, vars.codeSetBundleList, vars.QuantityUnitId)
			},	
					
  			// Identifier
 			(vars.medicationRequest.identifier default [] map (i, iIndex)  ->
			{
				method: "POST",
				referenceId: "Identifier" ++ iIndex,
				url: "/services/data/v51.0/sobjects/Identifier",
		 		body: getIdentifierUpsert(i, "@{Medication.id}", (vars.codeSetBundleList.allCodeBundleSet filter ($.BundleType == "IDENTIFIER"))[0].Id)
			}),			
/*					
			//ClinicalEncounterProvider
			(vars.encounterRequest.participant default [] map (p, pIndex) ->
			{
				method: "POST",
				referenceId: "Provider",
				url: "/services/data/v51.0/sobjects/ClinicalEncounterProvider",
				body: getParticipantUpsert(p, "@{Encounter.id}")
				 
			}),		
			
			//ClinicalEncounterFacility
			(vars.encounterRequest.location default [] map (l, lIndex) ->
			{
				method: "POST",
				referenceId: "Facility",
				url: "/services/data/v51.0/sobjects/ClinicalEncounterFacility",
				body: getLocationUpsert(l, "@{Encounter.id}")
				 
			}),
			
			//ClinicalEncounterReason
			vars.codeSetBundleList.allCodeBundleSet filter ($.BundleType == "REASONCODE") default [] map (r, rIndex) ->
			{
				method: "POST",
				referenceId: "ReasonCode",
				url: "/services/data/v51.0/sobjects/ClinicalEncounterReason",
				body: getReasonCodeUpsert(r, "@{Encounter.id}")
			}
			/*
			(vars.encounterRequest.reasonCode default [] map (r, rIndex) ->
			{
				method: "POST",
				referenceId: "ReasonCode",
				url: "/services/data/v51.0/sobjects/ClinicalEncounterReason",
				body: getReasonCodeUpsert(r, "@{Encounter.id}")
				 
			}),	 */		
 					
		]
		
	)
}
