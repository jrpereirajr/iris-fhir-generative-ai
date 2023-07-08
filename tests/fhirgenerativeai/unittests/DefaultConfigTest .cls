Class fhirgenerativeai.unittests.DefaultConfigTest Extends %UnitTest.TestCase
{

Method OnBeforeAllTests() As %Status
{
    // Saves the orignal value of the config global
    Set globalName = ##class(fhirgenerativeai.Config).#ConfigName
    Set globalNameCopy = globalName_"Copy"
    Merge @globalNameCopy = @globalName
    Kill @globalName

    Return $$$OK
}

Method OnAfterAllTests() As %Status
{
    /// Restores the orignal value of the config global
    Set globalName = ##class(fhirgenerativeai.Config).#ConfigName
    Set globalNameCopy = globalName_"Copy"
    Kill @globalName
    Merge @globalName = @globalNameCopy
    Kill @globalNameCopy

    Return $$$OK
}

Method TestCreate()
{
    Set config = ##class(fhirgenerativeai.DefaultConfig).Create()

    // Verify that the configuration object is created
    Do $$$AssertNotEquals("", config)

    // Verify the default values of the configuration
    Do $$$AssertEquals("http://localhost:52773/fhir/r4", config.GetBaseURL())
    Do $$$AssertEquals("OPENAI_API_KEY", config.GetOpenAIAPIEnvKey())
    Do $$$AssertEquals("gpt-3.5-turbo", config.GetOpenAIChatModel())
    Do $$$AssertEquals("localhost:32783", config.GetSwaggerHost())
}

}
