<cfcomponent output="false">

    <cffunction name="request" access="remote" returnformat="json">
		
	    <cfscript>
		data = StructNew();
	    </cfscript>
	    
	    <cflock name="#arguments.request#" timeout="120" type="Exclusive">
		    
		    <cfscript>
			sleep(2000);
			</cfscript>
		
		</cflock>
	   
	    <cfreturn data />
	</cffunction>
	
	<cffunction name="setRequest" access="remote" returnformat="json">
	
	   <cfset data = StructNew()>
	
	   <cflock scope="Application" timeout="30" type="Exclusive">
	       <cfset Application.req = Now() />
	       <cfscript>
		      sleep(20000);
		   </cfscript>
	   </cflock>
	
	   <cfreturn data />
	</cffunction>
	
	<cffunction name="getRequest" access="remote" returnformat="json">
	
	   <cflock scope="Application" timeout="2" type="ReadOnly">
	       <cfset data = StructNew() />
	       <cfset data['req'] = Application.req />
	   </cflock>
	
	   <cfreturn data />
	</cffunction>

</cfcomponent>