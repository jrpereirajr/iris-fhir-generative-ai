Class fhirgenerativeai.unittests.ConfigTest Extends %UnitTest.TestCase
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

/// Test case to verify GetConfigValue method
Method TestGetConfigValue()
{
    Set config = ##class(fhirgenerativeai.Config).%New()
    
    // Test with an existing configuration value
    Set expected = "SomeValue"
    Set ^fhirgenerativeai("SomeKey") = expected
    Set actual = config.GetConfigValue("SomeKey")
    Do $$$AssertEquals(expected, actual, "GetConfigValue should return the correct value")

    // Test with a non-existing configuration value
    Set actual = config.GetConfigValue("NonExistingKey")
    Do $$$AssertEquals("", actual, "GetConfigValue should return an empty string for non-existing key")
}

/// Test case to verify SetConfigValue method
Method TestSetConfigValue()
{
    Set config = ##class(fhirgenerativeai.Config).%New()
    
    // Test setting a configuration value
    Set key = "SomeKey"
    Set expected = "SomeValue"
    Do config.SetConfigValue(key, expected)
    Set actual = ^fhirgenerativeai(key)
    Do $$$AssertEquals(expected, actual, "SetConfigValue should set the correct value in the global")

    // Test overwriting an existing configuration value
    Set newValue = "NewValue"
    Do config.SetConfigValue(key, newValue)
    Set actual = ^fhirgenerativeai(key)
    Do $$$AssertEquals(newValue, actual, "SetConfigValue should overwrite the existing value")

    // Test setting a configuration value with an empty key
    Set key = ""
    Do config.SetConfigValue(key, "")
    Set actual = ""
    Do $$$AssertEquals("", actual, "SetConfigValue should set an empty key in the global")
}

/// Test case to verify configurations
Method DefaultConfigTest(setConfigName As %String, getConfigName As %String, expected As %String, message As %String)
{
    Set config = ##class(fhirgenerativeai.Config).%New()
    
    // Test with a configured value
    Do $METHOD(config, setConfigName, expected)
    Set actual = $METHOD(config, getConfigName)
    Do $$$AssertEquals(expected, actual, message)
}

/// Test case to verify empty configurations
Method DefaultEmptyConfigTest(setConfigName As %String, getConfigName As %String, message As %String)
{
    Set config = ##class(fhirgenerativeai.Config).%New()

    // Test setting an empty value
    Set emptyURL = ""
    Do $METHOD(config, setConfigName, emptyURL)
    Set actual = $METHOD(config, getConfigName)
    Do $$$AssertEquals(emptyURL, actual, message)
}

/// Test case to verify BaseURL configuration
Method TestBaseURL()
{
    Do ..DefaultConfigTest("SetBaseURL", "GetBaseURL", "http://example.com/fhir", "GetBaseURL should return the configured BaseURL")
    Do ..DefaultEmptyConfigTest("SetBaseURL", "GetBaseURL", "SetBaseURL should set an empty BaseURL")
}

/// Test case to verify OpenAIAPIEnvKey configuration
Method TestOpenAIAPIEnvKey()
{
    Do ..DefaultConfigTest("SetOpenAIAPIEnvKey", "GetOpenAIAPIEnvKey", "http://example.com/fhir", "GetOpenAIAPIEnvKey should return the configured OpenAIAPIEnvKey")
    Do ..DefaultEmptyConfigTest("SetOpenAIAPIEnvKey", "GetOpenAIAPIEnvKey", "SetOpenAIAPIEnvKey should set an empty OpenAIAPIEnvKey")
}

/// Test case to verify OpenAIChatModel configuration
Method TestOpenAIChatModel()
{
    Do ..DefaultConfigTest("SetOpenAIChatModel", "GetOpenAIChatModel", "http://example.com/fhir", "GetOpenAIChatModel should return the configured OpenAIChatModel")
    Do ..DefaultEmptyConfigTest("SetOpenAIChatModel", "GetOpenAIChatModel", "SetOpenAIChatModel should set an empty OpenAIChatModel")
}

/// Test case to verify SwaggerHost configuration
Method TestSwaggerHost()
{
    Do ..DefaultConfigTest("SetSwaggerHost", "GetSwaggerHost", "http://example.com/fhir", "GetSwaggerHost should return the configured SwaggerHost")
    Do ..DefaultEmptyConfigTest("SetSwaggerHost", "GetSwaggerHost", "SetSwaggerHost should set an empty SwaggerHost")
}

}
