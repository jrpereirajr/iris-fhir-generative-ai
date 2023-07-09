/// Cube for log analysis
Class fhirgenerativeai.LogAnalyticsCube Extends %DeepSee.CubeDefinition [ DependsOn = fhirgenerativeai.LogConceptTable, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="LogAnalyticsCube" displayName="Log Analytics" description="Cube for log analysis" disabled="false" abstract="false" sourceClass="fhirgenerativeai.LogConceptTable" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="Type" disabled="false" hasAll="false" allCaption="All Type" allDisplayName="Type" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Type" disabled="false" sourceProperty="LogId.Type" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Desc" disabled="false" hasAll="false" allCaption="All Desc" allDisplayName="Desc" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Desc" disabled="false" sourceProperty="LogId.Desc" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Concept" disabled="false" hasAll="false" allCaption="All Concept" allDisplayName="Concept" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Concept" disabled="false" sourceProperty="Concept" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="4">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Date" disabled="false" hasAll="true" allCaption="All Timestamp" allDisplayName="Timestamp" sourceProperty="LogId.Timestamp" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="5">
      </level>
      <level name="Month" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="6">
      </level>
    </hierarchy>
  </dimension>
</cube>
}

/// Notification that this cube is about to be built.<br/>
/// If the build is invoked using a selected <var>pFactList</var>, this list will be passed to the callback in a $LB format.
ClassMethod %OnBuildCube(pFactList As %List) As %Status
{
    Do ##class(fhirgenerativeai.LogConceptTable).LoadConcepts()
    Quit $$$OK
}

Parameter DOMAIN;

}
