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

</cfcomponent>