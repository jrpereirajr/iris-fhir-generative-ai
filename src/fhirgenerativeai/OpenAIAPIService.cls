Class fhirgenerativeai.OpenAIAPIService Extends %RegisteredObject
{

Property OpenAIChatModel As %String;

Property OpenAIAPIEnvKey As %String;

Property Config As fhirgenerativeai.Config;

Property Logger As fhirgenerativeai.LogService;

Method %OnNew() As %Status
{
    Set ..Config = ##class(fhirgenerativeai.Config).%New()
    Set ..OpenAIAPIEnvKey = ..Config.GetOpenAIAPIEnvKey()
    Set ..OpenAIChatModel = ..Config.GetOpenAIChatModel()
    Return $$$OK
}

/// Use the OpenAI Chat API to generate a response
Method OpenAIChat(systemPrompt As %String, prompt As %String) As %SYS.Python [ Language = python ]
{
import iris
import openai
import os

# Get the OpenAI API key from OPENAI_API_KEY environment variable
openai_api_key = os.getenv(self.OpenAIAPIEnvKey)

# Set up your OpenAI API credentials
openai.api_key = openai_api_key

# Set up parameters for OpenAI
messages = [
    {"role": "system", "content": f"{systemPrompt}"},
    {"role": "user", "content": prompt},
]

# Set the ChatCompletion API parameters
params = {
    "model": self.OpenAIChatModel,
    "messages": messages
}
desc = iris.cls("fhirgenerativeai.LogCodes").Get("SendingUserPromptToOpenAI")
self.Logger.LogEntryPythonDict(desc, params)

# Generate a response from OpenAI using ChatCompletion API
response = openai.ChatCompletion.create(**params, request_timeout=59)
desc = iris.cls("fhirgenerativeai.LogCodes").Get("ReceivedResponseFromOpenAI")
self.Logger.LogEntryPythonDict(desc, response)

return response
}

}
