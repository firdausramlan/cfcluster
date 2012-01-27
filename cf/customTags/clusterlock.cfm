<cfif thisTag.ExecutionMode IS "start">
	<cfif not thisTag.HasEndTag>
		<cfabort showError="Missing end tag for CF_CLUSTERLOCK">
	</cfif>
	<cfif not StructKeyExists(attributes, "Name")>
		<cfabort showError="A lock name attribute must be specified">
	<cfelseif Len(Trim(attributes.Name)) IS 0>
		<cfabort showError="A lock name attribute cannot be a zero length string">
	</cfif>
	<cfparam name="attributes.Timeout" type="numeric" default="30">

	<!--- clear the locks for the machine when the first cf_clusterlock is called after a server restart --->
	<!--- prevent any server scope race conditions --->
	<cfif not StructKeyExists(Server, "machineName")>
		<cflock scope="server" type="exclusive" timeout="10">
			<cfif not StructKeyExists(Server, "machineName")>
				<cfset MN = createObject("java", "java.net.InetAddress").localhost.getHostName()>
				<!--- clear the locks in the table by machine name --->
				<cfquery name="DeleteLocks" datasource="CFLocks">
					DELETE FROM Locks
					WHERE MachineName = <cfqueryparam value="#MN#" cfsqltype="cf_sql_varchar" maxlength="30">
				</cfquery>				
				<!--- set the machinename value for the server --->
				<cfset StructInsert(Server, "machineName", MN)>
			</cfif>	
		</cflock>	
	</cfif>
	
	<cfset startTime = Now()>
	<cfset Inserted = False>
	<cfset thread = CreateObject("java", "java.lang.Thread")>
	<cfloop condition="((not Inserted) AND (DateDiff('s', startTime, Now()) LTE attributes.Timeout))">
		<cftry>
				<cfquery name="InsertLock" datasource="CFLocks">
					INSERT INTO Locks (LockName, MachineName) 
					VALUES (<cfqueryparam value="#attributes.Name#" cfsqltype="cf_sql_varchar" maxlength="30">,
							<cfqueryparam value="#server.MachineName#" cfsqltype="cf_sql_varchar" maxlength="30">)
				</cfquery>
				<cfset Inserted = True>
			<cfcatch>
			</cfcatch>
		</cftry>
		<cfset thread.sleep(500)>
	</cfloop>
	<cfif Inserted IS False>
		<cfthrow message="CF_CLUSTERLOCK timeout">
	</cfif>
<cfelseif thisTag.ExecutionMode IS "end">
	<!--- delete the lock --->
	<cfquery name="DeleteLocks" datasource="CFLocks">
		DELETE FROM Locks
		WHERE Lockname = <cfqueryparam value="#attributes.Name#" cfsqltype="cf_sql_varchar" maxlength="30">
	</cfquery>
</cfif>
