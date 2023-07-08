Class fhirgenerativeai.DefaultConfig
{

/// Creates a default configuration to the project
/// You can overwrite them as your needs
ClassMethod Create() As fhirgenerativeai.Config
{
    Set config = ##class(fhirgenerativeai.Config).%New()
    Do config.SetBaseURL("http://localhost:52773/fhir/r4")
    Do config.SetOpenAIAPIEnvKey("OPENAI_API_KEY")
    Do config.SetOpenAIChatModel("gpt-3.5-turbo")
    Do config.SetSwaggerHost("localhost:32783")

    Return config
}

}
