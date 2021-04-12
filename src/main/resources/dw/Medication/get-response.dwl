%dw 2.0
output application/json skipNullOn="everywhere"
// Import our FHIR Tools library
import dw::Medication::fhirtools
---

(vars.acc_medicationRLUwithCodeSetValues map (item, index) -> using (i = item) 
 	 
	fhirtools::getResponse(item, vars.unitOfMeasure_QuantityUnitIdLU, vars.manufacturerIdLU)

)[0]