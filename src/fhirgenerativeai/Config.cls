Class fhirgenerativeai.Config Extends %RegisteredObject
{

/// Paramter for the global name for configuration storage
Parameter ConfigName = "^fhirgenerativeai";

/// Base URL key parameter
Parameter BaseURLKey = "BASER_URL";

/// OpenAI API Key environment variable key parameter
Parameter OpenAIAPIEnvKey = "OPENAI_API_ENV_KEY";

/// OpenAI model key parameter
Parameter OpenAIChatModel = "OPENAI_CHAT_MODEL";

/// swagger host key parameter
Parameter SwaggerHost = "SWAGGER_HOST";

/// Get a value from the global configuration using global indirections
Method GetConfigValue(key As %String) As %String
{
    Set globalName = ..#ConfigName
    Return $Get(@globalName@(key))
}

/// Set a value in the global configuration using global indirections
Method SetConfigValue(key As %String, value As %String)
{
    If (key '= "") {
        Set globalName = ..#ConfigName
        Set @globalName@(key) = value   
    }
}

/// Get the base url for the FHIR server
Method GetBaseURL() As %String
{
    Return ..GetConfigValue(..#BaseURLKey)
}

/// Set the base url for the FHIR server
Method SetBaseURL(url As %String)
{
    Do ..SetConfigValue(..#BaseURLKey, url)
}

/// Get the environment key for the OpenAI API
Method GetOpenAIAPIEnvKey() As %String
{
    Return ..GetConfigValue(..#OpenAIAPIEnvKey)
}

/// Set the environment key for the OpenAI API
Method SetOpenAIAPIEnvKey(envVarName As %String)
{
    Do ..SetConfigValue(..#OpenAIAPIEnvKey, envVarName)
}

/// Get the OpenAI Chat Model
Method GetOpenAIChatModel() As %String
{
    Return ..GetConfigValue(..#OpenAIChatModel)
}

/// Set the OpenAI Chat Model
Method SetOpenAIChatModel(model As %String)
{
    Do ..SetConfigValue(..#OpenAIChatModel, model)
}

/// Get the Swagger host
Method GetSwaggerHost() As %String
{
    Return ..GetConfigValue(..#SwaggerHost)
}

/// Set the Swagger host
Method SetSwaggerHost(host As %String)
{
    Do ..SetConfigValue(..#SwaggerHost, host)
}

}
