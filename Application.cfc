<cfcomponent output="false">

    <cfscript>
	this.name = "CFCluster";
	this.datasource = "CFCluster";
	
	this.mappings['/root'] = GetDirectoryFromPath(GetCurrentTemplatePath());
	this.mappings['/lib']  = this.mappings['/root'] & 'cf/lib/';
	this.mappings['/core'] = this.mappings['/root'] & 'cf/core/';
	this.mappings['/svc']  = this.mappings['/root'] & 'cf/serviceBus/';
	
	this.customtagpaths = this.mappings['/root'] & 'cf/customTags';
	</cfscript>

    <cffunction name="onApplicationStart">
		
		<cflog file="CFCluster" application="no" text="[onApplicationStart] #CGI.REMOTE_ADDR#">
		
		<cfscript>
		sleep(2000);
		
		Application.svc = {};
		Application.reg = {};
		
		Application.reg = {
           mongodb = "sms",
           mongohost = "localhost",
           mongoport = "27017"          
        };
		
		Application.svc = {
			SessionManager = new core.SessionManager(),
			Util = new core.Util(),
			User = new svc.User()
		};
		
		Application.initialized = true;
		</cfscript>
	
	</cffunction>
	
	<cffunction name="onRequestStart" returnType="void">
		<cfargument name="request" required="true" />
		
		<cfscript>
		// explicit call onApplicationStart via url.reloadApp
		if(StructKeyExists(url, 'reloadApp')){
			lock name="reloadApp" timeout="120" type="exclusive" {
			    onApplicationStart();						
			}			
		}
		
		// force lock to queue all request when somebody hit reloadApp
		lock name="reloadApp" timeout="120" type="readOnly" {}
		
		if(StructKeyExists(url, 'logout') OR StructKeyExists(form, 'logout')){
		    Application.svc.SessionManager.logout();				
		}
		
		// check session status
		var sessionStatus = Application.svc.SessionManager.sessionStatus();
		
		if(NOT sessionStatus.loggedIn){
				
				// redirect if request not come from login.cfm, else process login request
				if(Not IsDefined('form.login')){
			        include "login.cfm";
			        abort; 								
				}
				else {
								
					// check user credential
				    var authorization = Application.svc.User.checkCredential(form.j_username,form.j_password);
				    
				    if(authorization.valid){
				    				    
				        // if authorized, create user session and update user info
				        
				        var credential = Application.svc.SessionManager.login(authorization);
				        var sessionData = Application.svc.User.getUserData(credential);
				        
				        Application.svc.SessionManager.setSession(sessionData);
				        
				        				    				    
				    }
				    else {
				        
				        
				        // if user not authorized, redirect to login.cfm and display error message
				        var loginError = true;
				        include "login.cfm";
				        abort;			    
				    
				    }
													
				}
	
		}
		else {
				
		    // if user already logged in, update timeactive and check session timeout
		    Application.svc.SessionManager.setSession({"lastactive"=Now()});

		}
		
		</cfscript>
		
		<cflog file="CFCluster" application="no" text="[onRequestStart]">
	
	</cffunction>
	
	<cffunction name="onApplicationEnd" returnType="void"> 
	    <cfargument name="ApplicationScope" required=true/>
	    
	    <!--- close mongodb connection --->
	    <cfscript>
		ApplicationScope.svc.SessionManager.closeConnection();
		</cfscript>
	    
	</cffunction>

</cfcomponent>