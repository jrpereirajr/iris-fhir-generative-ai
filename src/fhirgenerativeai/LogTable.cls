Class fhirgenerativeai.LogTable Extends %Persistent
{

Property SessionId As %String;

Property Type As %String(VALUELIST = ",INFO,WARNING,ERROR") [ InitialExpression = "INFO" ];

Property Desc As %String(MAXLEN = 1024);

Property Data As %String(MAXLEN = 32767);

Property Timestamp As %TimeStamp [ InitialExpression = {$ZDATETIME($ZTIMESTAMP, 3)} ];

Storage Default
{
<Data name="LogTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SessionId</Value>
</Value>
<Value name="3">
<Value>Data</Value>
</Value>
<Value name="4">
<Value>Timestamp</Value>
</Value>
<Value name="5">
<Value>Desc</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^fhirgenerativeai.LogTableD</DataLocation>
<DefaultData>LogTableDefaultData</DefaultData>
<IdLocation>^fhirgenerativeai.LogTableD</IdLocation>
<IndexLocation>^fhirgenerativeai.LogTableI</IndexLocation>
<StreamLocation>^fhirgenerativeai.LogTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
