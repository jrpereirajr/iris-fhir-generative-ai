Class fhirgenerativeai.LogCodes
{

Parameter ModelResponse = "Model response";

Parameter ReceivedUserPrompt = "Received user prompt";

Parameter GeneratedResponse = "Generated response";

Parameter GenericError = "Error";

Parameter ProcessedModelResponse = "Processed model response";

Parameter SendingUserPromptToOpenAI = "Sending user prompt to OpenAI";

Parameter ReceivedResponseFromOpenAI = "Received response from OpenAI";

Parameter SecurityLinter = "Security linter";

Parameter SecurityError = "Security Error";

Parameter ExecutingCode = "Executing code";

Parameter ExecuteCodeError = "Error executing code";

ClassMethod Get(parameter As %String) As %String
{
    Return $PARAMETER(, parameter)
}

}
