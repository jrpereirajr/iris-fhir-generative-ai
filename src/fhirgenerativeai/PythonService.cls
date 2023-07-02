Class fhirgenerativeai.PythonService Extends %RegisteredObject
{

Property Code As %String;

Property Logger As fhirgenerativeai.LogService;

Property FHIRClient As fhirgenerativeai.FHIRClientService;

Property CodeInjection As %String;

Method %OnNew() As %Status
{
    Set ..FHIRClient = ##class(fhirgenerativeai.FHIRClientService).%New()
    Return $$$OK
}

Method CallFHIR(fhirPath As %String) As %SYS.Python
{
    Return ..FHIRClient.CallFHIR(fhirPath)
}

Method ExecutePythonCode() As %SYS.Python [ Language = python ]
{
import iris
import sys, traceback

# add the iris import
self.Code = f"import iris, datetime\n{self.Code}"
if self.CodeInjection != "" :
    self.Code += f"""\n{self.CodeInjection}"""

# check code for security issues
results = self.ApplySecurityLinter()
desc = iris.cls("fhirgenerativeai.LogCodes").Get("SecurityLinter")
self.Logger.LogEntryPythonDict(desc, {"securityLinter": results})
if len(results['results']) > 0:
    desc = iris.cls("fhirgenerativeai.LogCodes").Get("SecurityError")
    self.Logger.LogEntryPythonDict(desc, {"code": self.Code, "issues": results})
    raise Exception("Code contains security issues")

# setup the global context to execute the code
gbls = {
    'self': self
}

# uses the Python environment to execute the code
desc = iris.cls("fhirgenerativeai.LogCodes").Get("ExecutingCode")
self.Logger.LogEntryPythonDict(desc, {"code": self.Code})

# first analyzes the code
try:
    exec(self.Code, gbls)
except Exception as e:
    error_msg = traceback.format_exc()
    desc = iris.cls("fhirgenerativeai.LogCodes").Get("ParseCodeError")
    self.Logger.LogEntryPythonDict(desc, {"error": error_msg})
    raise e

# if no issues was found, executes the code
try:
    result = gbls['get_answer']()
except Exception as e:
    error_msg = traceback.format_exc()
    desc = iris.cls("fhirgenerativeai.LogCodes").Get("ExecuteCodeError")
    self.Logger.LogEntryPythonDict(desc, {"error": error_msg})
    raise e

# if no execution error was found, returns the result
return result
}

Method ApplySecurityLinter() As %SYS.Python [ Language = python ]
{
import json
import os
import tempfile
import uuid

def run_bandit_on_python_code(python_code):
    # Generate a unique filename for the temporary Python file
    filename = str(uuid.uuid4()) + '.py'

    # Create a temporary directory to store the Python file and the Bandit results
    with tempfile.TemporaryDirectory() as tmpdir:
        # Write the Python code to a temporary file
        with open(tmpdir + '/' + filename, 'w') as f:
            f.write(python_code)

        # Run the Bandit command as a subprocess and capture the output to a file ommiting the output
        output_filename = tmpdir + '/' + str(uuid.uuid4()) + '-bandit-results.json'
        cmd = f"python3 -m bandit -f json -o {output_filename} -r {tmpdir + '/' + filename}"
        os.system(cmd)

        # Read the results from the JSON file and return them as a dictionary
        with open(output_filename, 'r') as f:
            results = json.load(f)

        return results

results = run_bandit_on_python_code(self.Code)
return results
}

}
