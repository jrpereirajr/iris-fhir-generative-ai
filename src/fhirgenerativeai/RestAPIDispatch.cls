Class fhirgenerativeai.RestAPIDispatch Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>

<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />
<Route Url="/get-answer" Method="POST" Call="GetAnswer" Cors="true"/>
<Route Url="/log/:sessionId" Method="GET" Call="GetLog" Cors="true"/>
</Routes>
}

ClassMethod SwaggerSpec() As %Status
{
    Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
    Do swagger.info.%Remove("x-ISC_Namespace")
    Set swagger.basePath = "/iris-fhir-generative-ai/api"
    Set swagger.info.title = "IntegratedML on FHIR examples API"
    Set swagger.info.version = "0.1"
    Set config = ##class(fhirgenerativeai.Config).%New()
    Set swagger.host = config.GetSwaggerHost()
    Write swagger.%ToJSON()
    Return tSC
}

/// Retrieves an answer from the FHIRGenerativeAIService.
ClassMethod GetAnswer() As %Status
{
    Set sc = $$$OK
    
    Do ##class(%REST.Impl).%SetContentType("application/fhir+json")
    If '##class(%REST.Impl).%CheckAccepts("application/json") {
        Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE, $$$ERROR($$$RESTBadAccepts)) 
        Quit $$$ERROR($$$RESTBadAccepts)
    }
    
    Set stringBody = %request.Content.Read($$$MaxStringLength)
    Set body = {}.%FromJSON(stringBody)

    Set service = ##class(fhirgenerativeai.FHIRGenerativeAIService).%New()
    Set service.UserPrompt = body.prompt
    Set answer = service.GetAnswer()
    Throw:('$IsObject(answer)) ##class(%Exception.General).%New("Error getting answer")

    Write answer.%ToJSON()
    Return sc
}

/// Returns details about an answer from the FHIRGenerativeAIService, identified by its sessionId.
ClassMethod GetLog(sessionId As %String) As %Status
{
    Set sc = $$$OK
    
    Do ##class(%REST.Impl).%SetContentType("text/plain")
    Do ##class(fhirgenerativeai.FHIRGenerativeAIService).RunInTerminal("", sessionId)
    Return sc
}

}
