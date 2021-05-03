%dw 2.0
import mergeWith from dw::core::Objects
output application/json
--- 
vars.medicationRequest mergeWith { id: vars.response.compositeResponse[0].body.id }

