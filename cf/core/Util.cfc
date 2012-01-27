<cfcomponent output="false">

    <cffunction name="setCookie" access="public" returnType="void" output="false">
		<cfargument name="name" type="string" required="true">
		<cfargument name="value" type="string" required="false">
		<cfargument name="expires" type="any" required="false">
		<cfargument name="domain" type="string" required="false">
		<cfargument name="httpOnly" type="boolean" required="false">
		<cfargument name="path" type="string" required="false">
		<cfargument name="secure" type="boolean" required="false">
		<cfset var args = {}>
		<cfset var arg = "">
		<cfloop item="arg" collection="#arguments#">
		    <cfif not isNull(arguments[arg])>
		        <cfset args[arg] = arguments[arg]>
		    </cfif>
		</cfloop>
		
		<cfcookie attributecollection="#args#">
	</cffunction>

</cfcomponent>