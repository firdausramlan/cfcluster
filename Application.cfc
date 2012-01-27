<cfcomponent output="false">

    <cfscript>
	this.name = "CFCluster";
	this.datasource = "CFCluster";
	
	</cfscript>

    <cffunction name="onApplicationStart">
		
		<cflog file="CFCluster" application="no" text="[onApplicationStart] #CGI.REMOTE_ADDR#">
	
	</cffunction>
	
	<cffunction name="onRequestStart" returnType="void">
		
		<cflog file="CFCluster" application="no" text="[onRequestStart]">
	
	</cffunction> 

</cfcomponent>