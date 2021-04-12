// This script create the FHIR OperationOutcome response which 
// is often used in error responses. See 
// http://hl7.org/fhir/R4/operationoutcome.html for reference.
%dw 2.0

// If a variable with issueSeverity is supplied then use that, otherwise 
// use the default value of 'error'.
var severity = if (!isEmpty(vars.issueSeverity)) vars.issueSeverity else "error"

// If a variable with issueCode is supplied then use that, otherwise 
// use the default value of 'invalid'.
var code = if (!isEmpty(vars.issueCode)) vars.issueCode else "code-invalid"

// If a variable with issueText is supplied then use that, otherwise 
// use the default error message.
var text = if (!isEmpty(vars.issueText)) vars.issueText else "An error occurred"

output application/json
---
{
	resourceType: "OperationOutcome",
	issue: [
		{
			severity: severity,
			code: code,
			details: {
				text: text
			}
		}
	]
}