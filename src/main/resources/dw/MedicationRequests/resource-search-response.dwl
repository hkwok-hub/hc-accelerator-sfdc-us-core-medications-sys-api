%dw 2.0
output application/json skipNullOn="everywhere"
// Import our FHIR Tools library
import dw::Medication::fhirtools

---
{

	resourceType : "Bundle",
	id: uuid(),
	meta: {
		lastUpdated: now()
	},
	"type": "searchset",
	total: sizeOf(flatten (vars.acc_medicationRLUwithCodeSetValues)),
    link: [
        {
            relation: "self",
            url: fhirtools::getLinkSelf()
        }
    ],
 	entry: (flatten (vars.acc_medicationRLUwithCodeSetValues)) map (item, index) ->  {
 	 
       fullUrl: fhirtools::getEntryUrl(item),
        search: {
            mode: "match"
       },
		// Build the final response from the accumulation variable.
		resource: fhirtools::getResponse(item)	  
		 
    }   

}