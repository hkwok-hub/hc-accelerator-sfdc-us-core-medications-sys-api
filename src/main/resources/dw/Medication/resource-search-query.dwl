%dw 2.0
output application/json skipNullOn = "everywhere"
import * from dw::core::Strings

fun mapQueryParams(params:Object) = params mapObject (value, key, index) -> {
  (
  	if (key as String == "code")
         HealthCloudGA__MedicationCode__c: (value)
    else if (key as String == "form")
         HealthCloudGA__MedicationProductFormCode__c: (value)
    else if (key as String == "identifier")
         Name: (value)
    else if (key as String == "ingredient")
         HealthCloudGA__MedicationKindLabel__c: (value)
    else if (key as String == "ingredient-code")
         HealthCloudGA__MedicationKindCode__c: (value)
    else if (key as String == "lot-number")
         HealthCloudGA__MedicationLotNumber__c: (value)
    else if ( key as String == "status" ) 
		Status : (value)
	else if (key as String == "expiration-date")
    	if((value) startsWith("gt"))
	        stringVal: "HealthCloudGA__MedicationExpiration__c > " ++ substringAfter((value), "t")
	    else if((value) startsWith("lt"))
	    	stringVal: "HealthCloudGA__MedicationExpiration__c < " ++ substringAfter((value), "t")
        else if((value) startsWith("ge"))
	        stringVal: "HealthCloudGA__MedicationExpiration__c >= " ++ substringAfter((value), "e")
	    else if((value) startsWith("le"))
	    	stringVal: "HealthCloudGA__MedicationExpiration__c <= " ++ substringAfter((value), "e")
	    else
	    	stringVal: "HealthCloudGA__MedicationExpiration__c=" ++ (value) ++ "T00:00:00Z"
	else null
	
 )
}
var paramCount = sizeOf(attributes.queryParams - "_count")
---
"SELECT 
CreatedById,
CreatedDate,
Id,
IsDeleted,
IsLocked,
LastModifiedById,
LastModifiedDate,
LastReferencedDate,
LastViewedDate,
ManufacturerId,
MayEdit,
MedicationCodeId,
MedicationFormId,
Name,
OwnerId,
QuantityDenominator,
QuantityNumerator,
QuantityUnitId,
SourceSystem,
SourceSystemIdentifier,
SourceSystemModified,
Status,
SystemModstamp 
FROM Medication" replace /\n/ with " " ++ 
(if (paramCount > 0) (
	" WHERE " ++
    (
    	(mapQueryParams(attributes.queryParams) pluck (value, key, index) ->
    		(
    		// If stringVal is found, just use the value. 
    		// This is here so that custom conditions can be added.
                if (key ~= "stringVal" and !isEmpty(value)) "(" ++ value ++ ")" 
                else if (key ~= "Actively_Taking__c") "(" ++ key ++ "=" ++ value ++ ")"
                else "(" ++ key ++ "='" ++ value ++ "'" ++ ")"
            )
    	) 
        joinBy " AND "
    )
) else "")
++ " LIMIT " ++ (
	if (!isEmpty(attributes.queryParams."_count")) 
		(attributes.queryParams."_count" as String) 
	else p('http.defaultRecoredLimit')
)
