<!DOCTYPE HTML>
<html>
<head>
	
	<meta charset="utf-8">
    <title>CFCluster</title>
	
</head>
<body>
	
	<hr>
	
	
	<h3>Current User Info</h3>
	<cfscript>
	WriteDump(Application.svc.SessionManager.getSession());
	</cfscript>
	
	<hr>
	
	<h3>Get All Session</h3>
	<cfscript>
	WriteDump(Application.svc.SessionManager.getAllSession());
	</cfscript>
	
	<hr>
	
	<h3>Count Session</h3>
	<cfscript>
	WriteDump(Application.svc.SessionManager.getCount());
	</cfscript>
	

</body>
</html>