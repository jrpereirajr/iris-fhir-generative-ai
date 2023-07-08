Class fhirgenerativeai.FHIRGenerativeAIService Extends %RegisteredObject
{

Property SessionId As %String;

Property UserPrompt As %String;

Property Config As fhirgenerativeai.Config;

Property Logger As fhirgenerativeai.LogService;

Property PromptService As fhirgenerativeai.PromptService;

Property OpenAIAPIService As fhirgenerativeai.OpenAIAPIService;

Property PythonService As fhirgenerativeai.PythonService;

Method %OnNew() As %Status
{
    Set ..SessionId = ..CreateUUID()

    Set ..Config = ##class(fhirgenerativeai.Config).%New()
    
    Set ..Logger = ##class(fhirgenerativeai.LogService).%New()
    Set ..Logger.SessionId = ..SessionId

    Set ..PromptService = ##class(fhirgenerativeai.PromptService).%New()

    Set ..OpenAIAPIService = ##class(fhirgenerativeai.OpenAIAPIService).%New()
    Set ..OpenAIAPIService.Logger = ..Logger

    Set ..PythonService = ##class(fhirgenerativeai.PythonService).%New()
    Set ..PythonService.Logger = ..Logger

    Return $$$OK
}

Method GetAnswer() As %DynamicObject [ Language = python ]
{
import iris
import json
import sys, traceback

#; self.UserPrompt.Read(3641144)

try:
    desc = iris.cls("fhirgenerativeai.LogCodes").Get("ReceivedUserPrompt")
    self.Logger.LogEntryPythonDict(desc, {"prompt": self.UserPrompt})

    openai_response = self.GetOpenAIResponse()
    text_response = self.ExtractModelResponse(openai_response)
    processed = self.ParseModelResponse(text_response)

    self.PythonService.Code = processed['response']['code']
    result = self.PythonService.ExecutePythonCode()

    resp = {
        'sessionId': self.SessionId,
        'result': result,
        'code': processed['response']['code'],
        'desc': processed['response']['desc']
    }
    desc = iris.cls("fhirgenerativeai.LogCodes").Get("GeneratedResponse")
    self.Logger.LogEntryPythonDict(desc, resp)
    
    return iris.cls("%DynamicObject")._FromJSON(json.dumps(resp))
except Exception as e:
    error_msg = f"sessionId: {self.SessionId}\n{traceback.format_exc()}"
    desc = iris.cls("fhirgenerativeai.LogCodes").Get("GenericError")
    self.Logger.LogEntryPythonDict(desc, {"error": error_msg})
    raise Exception(error_msg)
}

Method GetOpenAIResponse() As %SYS.Python [ Language = python ]
{
import iris
system_prompt = self.PromptService.GetSystemTemplate()
user_prompt = self.PromptService.FormatUserPrompt(self.UserPrompt)
openai_response = self.OpenAIAPIService.OpenAIChat(system_prompt, user_prompt)

return openai_response
}

Method ExtractModelResponse(openaiResponse As %SYS.Python) [ Language = python ]
{
import iris

# Extract the generated response from the API response
generated_texts = [
    choice.message["content"].strip() for choice in openaiResponse["choices"]
]

# Return the generated response
text_response = "\n".join(generated_texts)
desc = iris.cls("fhirgenerativeai.LogCodes").Get("ModelResponse")
self.Logger.LogEntry(desc, text_response)
return text_response
}

Method ParseModelResponse(textResponse As %String) As %SYS.Python [ Language = python ]
{
# uses the xmltodict library to parse the response
import iris, xmltodict
processed = xmltodict.parse(textResponse)
desc = iris.cls("fhirgenerativeai.LogCodes").Get("ProcessedModelResponse")
self.Logger.LogEntryPythonDict(desc, processed)
return processed
}

ClassMethod CreateUUID() As %String [ Language = python ]
{
import uuid
return uuid.uuid4().hex
}

ClassMethod RunInTerminal(prompt As %String = "", sessionId As %String = "", codeInjection As %String = "") [ Language = python ]
{
import iris, json

service = iris.cls("fhirgenerativeai.FHIRGenerativeAIService")._New()
if sessionId == "":
    sessionId = service.SessionId
    print("Generating the answer...")
    service.UserPrompt = prompt
    if codeInjection != "":
        service.PythonService.CodeInjection = codeInjection
    try:
        service.GetAnswer()
    except:
        pass
else:
    print("Retrieving the answer...")

hr = "-"*80
print(hr)
print(f"SessionId:\n{sessionId}")
print(hr)

map = {
    'Executing code': "code", 
    'Received user prompt': "prompt"
}

sql = """select "Desc", Data from fhirgenerativeai.LogTable where SessionId = ?"""
rs = iris.cls("%SQL.Statement")._ExecDirect("", sql, sessionId)

if rs._SQLCODE != 0 and rs._SQLCODE != 100:
    raise Exception(rs._SQLCODE,rs._Message)

logCode = iris.cls("fhirgenerativeai.LogCodes")
while rs._Next():
    print(f"{rs.Desc}:")
    if rs.Desc in [
        logCode.Get("SecurityLinter"),
        logCode.Get("ProcessedModelResponse"),
        logCode.Get("ReceivedResponseFromOpenAI"),
        logCode.Get("SendingUserPromptToOpenAI")
    ]:
        json_object = json.loads(rs.Data)
        json_formatted_str = json.dumps(json_object, indent=2)
        print(json_formatted_str)
    elif rs.Desc in map.keys():
        json_object = json.loads(rs.Data)
        print(json_object[map[rs.Desc]])
    elif rs.Desc == logCode.Get("GeneratedResponse"):
        json_object = json.loads(rs.Data)
        print(f"{json_object['desc']}\nResult: {json_object['result']}")
    elif rs.Desc == logCode.Get("SecurityError"):
        json_object = json.loads(rs.Data)
        print(f"{json_object['code']}\nIssues: {json_object['issues']}")
    else:
        print(rs.Data)
    print(hr)
}

ClassMethod RunInTerminalOutputToFile(file As %String, prompt As %String = "", sessionId As %String = "", codeInjection As %String = "") [ Language = python ]
{
import iris
import sys

# Open a file in write mode
with open(file, 'w') as f:
    # Redirect sys.stdout to the file
    sys.stdout = f

    # Print statements will now be written to the file
    iris.cls("fhirgenerativeai.FHIRGenerativeAIService").RunInTerminal(prompt, sessionId, codeInjection)

    # Reset sys.stdout to the original value (console)
    sys.stdout = sys.__stdout__
}

}
