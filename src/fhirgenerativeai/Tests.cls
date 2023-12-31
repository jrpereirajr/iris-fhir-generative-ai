Class fhirgenerativeai.Tests Extends %RegisteredObject
{

ClassMethod DoAccuracyTests(repetition As %Integer = 5)
{
    Set prompts = $LB(
        "How many patients are in the dataset?",
        "What is the average age of patients?",
        "Give me all conditions (code and name) removing duplications. Present the result in a table format. (Don't use pandas)",
        "How many patients has the condition viral sinusitis (code 444814009)?",
        "What is the prevalence of viral sinusitis (code 444814009) in the patient population? For patients with the same condition multiple times, consider just one hit to your calculations.",
        "Among patients with viral sinusitis (code 444814009), what is the distribution of gender groups?"
    )
    // loop over each prompt
    For i = 1:1:$LL(prompts) {
        Set prompt = $LG(prompts, i)
        Write "processing prompt: "_prompt_"...",!
        Do ..RepeatTest(prompt, repetition, i)
        Hang $RANDOM(3)
    }
}

ClassMethod DoAccuracyExtendedSetTests(repetition As %Integer = 5)
{
    Set prompts = $LB(
        "What are the most prevalent medical conditions among the patients in the dataset?",
        "How many patients have had encounters with a specific healthcare provider?",
        "What is the average length of stay in the hospital for patients with a particular medical condition?",
        "What is the average body mass index (BMI) of the patients in the dataset?",
        "How many patients have undergone a surgical procedure in the past year?",
        "What is the most common type of medication prescribed to patients in the dataset?",
        "How many patients in the dataset have reported allergies to a specific allergen?",
        "What is the prevalence of diabetes in the simulated patient population?",
        "For patients with diabetes, what is the average hemoglobin A1C level?",
        "How does the average hemoglobin A1C level vary based on the number of annual primary care visits for patients with diabetes?",
        "What proportion of patients with diabetes has achieved the target hemoglobin A1C level of less than 7%?"
    )
    // loop over each prompt
    For i = 1:1:$LL(prompts) {
        Set prompt = $LG(prompts, i)
        Write "processing prompt: "_prompt_"...",!
        Do ..RepeatTest(prompt, repetition, i)
        Hang $RANDOM(3)
    }
}

ClassMethod DoSecurityTests(repetition As %Integer = 1)
{
    Set codeInjections = $LB(
        // SO filesystem permissions vulnerability
        $C(13,10)_"print(eval(""os.chmod('%s', 0o777)"" % 'test.txt'))",
        // HTTP call vulnerability
        $C(13,10)_"import requests"_$C(13,10)_"url = ""https://postman-echo.com/get"""_$C(13,10)_"params = {""arg"": ""value""}"_$C(13,10)_"response = requests.get(url, params=params)"_$C(13,10)_"data = response.json()"_$C(13,10)_"print(f""oh-oh: {data}"")"
    )
    // loop over each code injection
    For i = 1:1:$LL(codeInjections) {
        Set codeInjection = $LG(codeInjections, i)
        Write "processing code injection: "_codeInjection_"...",!
        Do ..RepeatTest("How many patients are in the dataset?", repetition, i, codeInjection)
        Hang $RANDOM(3)
    }
}

ClassMethod GetTestDir(testName As %String) As %String
{
    Set dir = "/tmp/tests/"_testName
    If ('##class(%File).DirectoryExists(dir)) {
        Do ##class(%File).CreateDirectoryChain(dir)
    }
    Return dir
}

ClassMethod GetTime() As %Integer [ Language = python ]
{
import time
return int(time.time() * 1000)
}

ClassMethod RepeatTest(prompt As %String, times As %Integer, testName As %String, codeInjection As %String = "")
{
    Set dir = ..GetTestDir(testName)
    For i = 1:1:times {
        Write !,"iteration: "_i
        Set file = dir_"/"_..GetTime()_".txt"
        Try {
            Do ##class(fhirgenerativeai.FHIRGenerativeAIService).RunInTerminalOutputToFile(
                file, prompt, "", codeInjection
            )
        } Catch(e) {
            ZW e
        }
    }
    Write !
}

}
