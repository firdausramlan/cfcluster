<!DOCTYPE HTML>
<html>
<head>
	
	<meta charset="utf-8">
    <title>CFCluster</title>
	
</head>
<body>
	
	<cfdump var="#Now()#">
	<cfdump var="#Application.initialized#">
	
	<cfif IsDefined("cflogin")>
	   <cfdump var="#cflogin#">
	</cfif>
	
	<cfset result = Application.svc.SessionManager.session.findById("4f22949d9217f6f23016b5ce")>
	<cfset WriteDump(IsDefined('result'))>
	
	<!---
	<cfset result = Application.svc.SessionManager.session.query().$eq('_id', '4f22949d9217f6f23016b5cf').find()>
	<cfdump var="#result.asArray()#">
	--->
	
	<cfdump var="#Application.svc.SessionManager.sessionStatus()#">
	
	<cfdump var="#cookie#">
	
	<cfscript>
	//m = "Mongo";
	//a = new "lib.cfmongodb.core.#m#"();
	//a = new svc.Test();
	//WriteDump(a);
	</cfscript>

</body>
</html>