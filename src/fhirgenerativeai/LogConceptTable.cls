Class fhirgenerativeai.LogConceptTable Extends %Persistent
{

Property LogId As fhirgenerativeai.LogTable;

Property Concept As %String(MAXLEN = 1024);

Index IdxLogId On LogId;

ClassMethod LoadConcepts()
{
    Set sql = "select Id, Data from fhirgenerativeai.LogTable where Id not in (select LogId from fhirgenerativeai.LogConceptTable)"
    Set rs = ##class(%SQL.Statement).%ExecDirect(,sql)
    While (rs.%Next()) {
        Write rs.Id,!
        Do ..SaveConcepts(rs.Id, rs.Data)
    }
}

/// This code was heavily inspired by [this one](https://github.com/isc-tdyar/iris-fhirsqlbuilder-dbt-integratedml/blob/master/src/User/funcGetEntitiesList.cls).
ClassMethod SaveConcepts(logId As %Integer, text As %String) [ Language = python ]
{
    import iris
    import iknowpy

    engine = iknowpy.iKnowEngine()

    # index some text
    engine.index(text, 'en')
    t_output = ""

    # or make it a little nicer
    for s in engine.m_index['sentences']:
        for e in s['entities']:
            if e['type'] == 'Concept':
                #; t_output = t_output  + e['index']+ "|"
                iris.cls(__name__).SaveRegistry(logId, e['index'])
}

ClassMethod SaveRegistry(logId As %Integer, concept As %String)
{
    Set reg = ##class(fhirgenerativeai.LogConceptTable).%New()
    Do reg.LogIdSetObjectId(logId)
    Set reg.Concept = concept
    $$$TOE(st, reg.%Save())
}

Storage Default
{
<Data name="LogConceptTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LogId</Value>
</Value>
<Value name="3">
<Value>Concept</Value>
</Value>
</Data>
<DataLocation>^fhirgenera4F3E.LogConceptT8B63D</DataLocation>
<DefaultData>LogConceptTableDefaultData</DefaultData>
<IdLocation>^fhirgenera4F3E.LogConceptT8B63D</IdLocation>
<IndexLocation>^fhirgenera4F3E.LogConceptT8B63I</IndexLocation>
<StreamLocation>^fhirgenera4F3E.LogConceptT8B63S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
