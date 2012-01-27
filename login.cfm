<!--- explicit call to login.cfm should force logout --->
<cfset Application.svc.SessionManager.logout() />
<cfheader statuscode="401">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
    
    <meta charset="utf-8">
    <title>CFCluster</title>
    
</head>
<body>
    
	<form method="post" action="index.cfm">
		
		<input type="hidden" name="login">
	
	   <div align="center">
		   
		   <h3>CFCluster Login</h3>
	
	       <label>U: </label>
		   <input type="text" name="j_username" maxlength="8">
		   <br />
		   
		   <label>P: </label>
		   <input type="password" name="j_password" maxlength="8">
		   <br /><br />
		   
		   <input type="submit" value="Login">
		   <br /><br />
		   
		   <cfif isDefined('loginError') AND loginError>
		      <span style="color:Crimson;">Login Invalid</span>
		   </cfif>
		   
	   
	   </div>
	
	</form>
    
</body>
</html>