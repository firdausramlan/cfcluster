<cfcomponent output="false">

    <cffunction name="checkCredential">
	   <cfargument name="username" type="String" required="true">
	   <cfargument name="password" type="String" required="true">
	   
	   <cfset var credential = {} />
	   
	   <cfquery name="credential.result" datasource="SMS">
	   SELECT
	       p.uid as userid
	   FROM
	       `profiles` p
	   WHERE
	       p.username = "#username#" AND
           p.password = password("#password#") AND
           p.status = 1
       LIMIT 1 
	   </cfquery>
	   
	   <cfset credential.valid = credential.result.recordcount NEQ 0>	   
	
	   <cfreturn credential />
	</cffunction>
	
	<cffunction name="getUserData">
		<cfargument name="credential" type="Struct" required="true">
		
		<cfset var s = {}>
		
		<cfquery name="getData" datasource="SMS">
		SELECT
		  p.name as nama,
		  p.designation as designation,
		  p.phone as phone
		FROM
		  `profiles` f
		  INNER JOIN personnel p ON (f.personnel_id = p.uid)
		WHERE
		  f.uid = '#credential.userid#'
		LIMIT 1
		</cfquery>
		
		<cfif getData.recordcount>
		
		    <cfloop list="#getData.columnList#" index="sessionkey">
			    <cfset s[lcase(sessionkey)] = getData[sessionkey][1] />
			</cfloop>
		
		</cfif>
	
	   <cfreturn s />
	</cffunction>

</cfcomponent>