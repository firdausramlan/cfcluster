component {
	
	function init(){
	
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
        variables.me.sessions = variables.me.mongo.getDBCollection('sessions');
		
		return this;
	
	}
	
	function login(auth){

        var credential = {};
		var info = {
		    "ip"      = CGI.REMOTE_ADDR,
		    "logints" = Now(),
		    "userid"  = auth.result.userid         
		};
		
		// insert document in mongo
		var auth_key = variables.me.sessions.save(info);
		var newSession = variables.me.sessions.findById(auth_key);
		newSession['auth_key'] = auth_key.toString();
		variables.me.sessions.update(newSession);
		
		Application.svc.Util.setCookie(
		    name     = "sms_auth_key",
		    value    = auth_key,
		    expires  = 2,
		    httpOnly = true
		);
		
		credential = getSession();
		
		return credential;	
	}
	
	function logout(){
	
        var logout = {};
       
        if(StructKeyExists(cookie, 'sms_auth_key') AND cookie.sms_auth_key NEQ ''){
	        variables.me.sessions.removeById(cookie.sms_auth_key);
			Application.svc.Util.setCookie(
			    name="sms_auth_key",
			    expires="now"
			);
			StructDelete(cookie, 'sms_auth_key');
        }
		
		return logout;	
	}
	
	function sessionStatus(){
	
        var status = {
            "loggedIn" = false
        };
        
        // - check client cookie for auth key
        // - if exist check document in mongo 
        // - optionally check timeout
        if(StructkeyExists(cookie, 'sms_auth_key')){
		  var s = getSession();
          status['loggedIn'] = StructKeyExists(s, 'auth_key');                
        }
		
        return status;
	}
	
    function setSession(struct partialDoc){
        
        variables.me.sessions.update(
            doc = {"$set" = partialDoc},
            query = {"auth_key" = cookie.sms_auth_key}
        );
        
    }
	
	function getSession(){
	    var s = {};
        var sArr = variables.me.sessions.query().$eq('auth_key', cookie.sms_auth_key).find(limit=1,keys="_id=0").asArray();
        
		if(ArrayLen(sArr)){
		    s = sArr[1];
		}
		
		return s;
    }
	
	function getAllSession(){
	    var s = variables.me.sessions.find(keys="_id=0");
        return s.asArray();
	}
	
	function getCount(){
		return variables.me.sessions.count();		
	}
	
	function checkDuplicateSession(){}
	
	function purgeAllSession(){}
	
	// invoke this when application end
	function closeConnection(){
		variables.me.mongo.close();		
	}

}