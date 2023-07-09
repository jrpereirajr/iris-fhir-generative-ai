Class fhirgenerativeai.Utils
{

/// Copied from https://github.com/intersystems-community/iris-analytics-template/blob/master/src/dc/irisbi/covid19cube.cls
ClassMethod EnableIRISBI(ns As %String) As %Status
{
    Set sc = $$$OK
    set ns=$g(ns) 
    if ns="" set ns=$ZNSPACE
    set ns=$$$LOWER(ns)
    do EnableDeepSee^%SYS.cspServer("/csp/"_ns_"/")
    Return sc
}

}
