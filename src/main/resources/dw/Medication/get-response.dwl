%dw 2.0
output application/json skipNullOn="everywhere"
// Import our FHIR Tools library
import dw::Medication::fhirtools
---

(flatten (vars.acc_medicationRLUwithCodeSetValues) map (item, index) -> // using (i = item) 
	
	fhirtools::getResponse(item)	

)[0]