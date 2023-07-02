Class fhirgenerativeai.LogService Extends %RegisteredObject
{

Property SessionId As %String;

Method %OnNew() As %Status
{
    Set:(..SessionId = "") ..SessionId = ##class(fhirgenerativeai.FHIRGenerativeAIService).CreateUUID()
    Return $$$OK
}

Method LogEntry(desc As %String, message As %String, type As %String = "INFO")
{
    Set entry = ##class(fhirgenerativeai.LogTable).%New()
    Set entry.SessionId = ..SessionId
    Set entry.Type = type
    Set entry.Desc = desc
    Set entry.Data = message
    $$$TOE(st, entry.%Save())
}

Method LogEntryJSON(desc As %String, message As %DynamicObject, type As %String = "INFO")
{
    Set data = {}.%ToJSON(message)
    Do ..LogEntry(desc, data, type)
}

Method LogEntryPythonDict(desc As %String, message As %SYS.Python, type As %String = "INFO") [ Language = python ]
{
import iris
import json
self.LogEntry(desc, json.dumps(message), type)
}

}
