<cfcomponent output="false">
	
	<cffunction name="init" output="false">
		
		<cfscript>
		variables.me.mongoConfig = new lib.cfmongodb.core.MongoConfig(
		    dbName = Application.reg.mongodb,
		    hosts = [
		      {
		          serverName = Application.reg.mongohost,
		          serverPort = Application.reg.mongoport
		      }
		    ]
		);
		
		variables.me.mongo = new lib.cfmongodb.core.Mongo(variables.me.mongoConfig);
		this.session = variables.me.mongo.getDBCollection('session');
		</cfscript>
	   
	   <cfreturn this />
	</cffunction>
	
	<cffunction name="login" output="true">
	
	   <cfscript>
	   var credential = {};
	   var info = {
	   	   "ip" = CGI.REMOTE_ADDR	   	   
	   };
	   
	   // insert document in mongo
	   var auth_key = this.session.save(info);
	   
	   Application.svc.Util.setCookie(
	       name     = "sms_auth_key",
	       value    = auth_key,
	       expires  = 2,
	       httpOnly = true
	   );
	   
	   </cfscript>
	
	   <cfreturn credential>
	</cffunction>
	
	<cffunction name="logout" output="false">
	
	   <cfscript>
	   var logout = {};
	   
	   // delete document in mongo
	   
	   Application.svc.Util.setCookie(
	       name="sms_auth_key",
           expires="now"
	   );
	   
	   </cfscript>
	
	   <cfreturn logout />
	</cffunction>

    <cffunction name="sessionStatus" output="false">
		
		<cfscript>
		var status = {
			"loggedIn" = false
		};
		
		// check client cookie for auth key, if exist check document in mongo
		if(StructkeyExists(cookie, 'sms_auth_key')){
		  status['loggedIn'] = true;				
		}
		</cfscript>
	
	   <cfreturn status />
	</cffunction>
	
	<cffunction name="getSession" output="false">
	
	</cffunction>
	
	<cffunction name="setSession" output="false">
	
	</cffunction>
	
	<cffunction name="getAllSession" output="false">
	
	</cffunction>
	
	<cffunction name="purgeAllSession" output="false">
	
	</cffunction>
	
	<cffunction name="dumpPrivate" output="false">
	
	   <cfreturn variables.me />
	
	</cffunction>

</cfcomponent>