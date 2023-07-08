Class fhirgenerativeai.FHIRClientService Extends %RegisteredObject
{

/// Base URL
Property BaseURL As %String;

Property Config As fhirgenerativeai.Config;

Method %OnNew() As %Status
{
    Set ..Config = ##class(fhirgenerativeai.Config).%New()
    Set ..BaseURL = ..Config.GetBaseURL()
    Return $$$OK
}

/// A simple FHIR client for quick testing
Method CallFHIR(fhirPath As %String) As %SYS.Python [ Language = python ]
{
import iris
import requests

# set the base URL
base_url = self.BaseURL

# set the FHIR path
fhir_url = f"{base_url}/{fhirPath}"

# set the headers
headers = {
    "Accept": "application/fhir+json",
    "Content-Type": "application/fhir+json"
}

# set the request parameters
params = {
    "url": fhir_url,
    "headers": headers
}
#print("-"*80)
#print("params:")
#print(params)

# make the request
response = requests.get(**params)

# return the response
if response.status_code == 200:
    json_response = response.json()
    return json_response
else:
    # raise an exception with the response code and reason
    raise Exception(response.status_code, response.reason)
}

}
