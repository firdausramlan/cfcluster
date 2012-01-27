<cfcomponent output='false'>

    <cffunction name="read" access="remote" returnformat="json">
	
	    <cftransaction action="begin" isolation="REPEATABLE_READ">
		
		    <cfquery datasource="locking">
			INSERT INTO a(f1) values('#arguments.request#')
			</cfquery>
			
			<cfset sleep(1000)>

	        <cfquery name="data" datasource="locking">
	        SELECT count(f1) as f1 FROM a
	        </cfquery>
	        
		    <cfreturn data.f1 />
	    </cftransaction>
	
	</cffunction>

</cfcomponent>