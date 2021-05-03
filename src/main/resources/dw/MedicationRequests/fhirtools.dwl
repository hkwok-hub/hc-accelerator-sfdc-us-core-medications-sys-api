/**
 * encounterFHIRTools DataWeave library contains functions used for converting HealthCloud data into FHIR format.
 */
 
 %dw 2.0

/**
 * Import Dataweave Runtime library
 */
import * from dw::Runtime

/**
 * Generates the FHIR response with the 
 * provided Encounter Object.
 * @param encounterRLU is the Encounter object to map.
 * @return A HealthCloud ClientEncounter response.

 */

fun getResponse(objRLU) = using ( identifierRLU = objRLU.Identifiers
										//		encountersRLU = objRLU.ClinicalEncounters,
										//		reasonsRLU = encounterRLU.ClinicalEncounterReasons,
										//		facilityRLU = encounterRLU.Clinical_Encounter_Facility,
										//		diagnosesRLU = encounterRLU.ClinicalEncounterDiagnoses,
										//		providersRLU = encounterRLU.Clinical_Encounter_Providers
										) 
{
	
 	resourceType: "Medication",
	id: objRLU.Id,


    // Identifier
    (if (!isEmpty(identifierRLU.IdValue))
    
   
    identifier: 
	identifierRLU map (i) ->
        {
            use: lower(i.IdUsageType),
            value: i.IdValue,
            system: i.SourceSystem,
          	"type":  {
          		(objRLU.IdentifierstBundle filter ($.Id == i.IdTypeId) map (ib, ibIndex) ->
          			{"coding": ib.IdentifiersCodeSets map (ics, icsIndex) ->
			          		{
			          			 
			          			"system": ics.SourceSystem,
								"version": ics.SystemVersion,
								"code": ics.Code,
								"display": ics.Name,
			          		},
			      "text":  ib.Name
			      })
          		
          	}
            		 
              
            
        }
      
    else null),
    
   //meta
	meta: {
		profile: [
	      "http://hl7.org/fhir/us/core/StructureDefinition/us-core-medication"
	    ]
	 },

	//code
	 "code":
	  {
           		 	  	
		    "coding": 
		    objRLU.MedicationCodeIdCodeSets map (c, cIndex) -> 
		    {
				"system": c.SourceSystem,
				"version": c.SystemVersion,
				"code": c.Code,
				"display": c.Name,
	         },
	         text: objRLU.MedicationCodeIdCodeSetBundle.Name
	    
	    },
	
    //status
	"status": lower(objRLU.Status),
	
	//manufacturer
	(if (!isEmpty(objRLU.manufacturerIdLU))
    "manufacturer": {
        reference: "Organization/" ++ objRLU.manufacturerIdLU.Id[0]
    }
    else null),
    
    
	//form
	 "form":
	  {
           		 	  	
		    "coding": 
		    objRLU.MedicationFormIdCodeSets map (c, cIndex) -> 
		    {
				"system": c.SourceSystem,
				"version": c.SystemVersion,
				"code": c.Code,
				"display": c.Name,
	         },
	         text: objRLU.MedicationFormIdCodeSetBundle.Name
	    
	    },	
	
	//amount
	(if (!isEmpty(objRLU.QuantityNumerator) or (!isEmpty(objRLU.QuantityDenominator)))
	"amount": 
	{
		
		numerator:{
          "value": objRLU.QuantityNumerator as Number ,
          //"system": "http://unitsofmeasure.org",
          //"unit": unitOfMeasure[0].UnitCode	
          "unit": objRLU.unitOfMeasure_QuantityUnitIdLU.UnitCode[0]	
		},
		
		denominator:{
          "value": objRLU.QuantityDenominator as Number ,
         // "system": "http://unitsofmeasure.org",
          "unit": objRLU.unitOfMeasure_QuantityUnitIdLU.UnitCode[0]		
		}
		
	}else null)
	   
  
}


/**
 * Gets the URL to the current web resource.
 * @param attr is an object with the attributes.
 * @return A string with the self link.
 */
fun getLinkSelf() = Mule::p("fhir.host") ++ Mule::p("fhir.requestUri")

/**
 * Gets the URL for the entry provided.
 * @param item is an object with the item that's being returned.
 * @param attr is an object with the attributes.
 * @return A string with the entry URL.
 */
fun getEntryUrl(item:Object) = Mule::p("fhir.host") ++ "/Medication/" ++ item.Id