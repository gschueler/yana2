<html>
<head>
	<meta name='layout' content='main'/>
	<title><g:message code="springSecurity.login.title"/></title>
</head>

<body>
<div class="vertsect " >
<div id='login' >
	<div class='auth well ' >


		<g:if test='${flash.message}'>
			<div class='login_message'>${flash.message}</div>
		</g:if>

		<form action='${postUrl}' method='POST' id='loginForm' class='form-horizontal' autocomplete='off'>
            <legend><g:message code="springSecurity.login.header"/></legend>
			<div class="control-group">
				<label class="control-label" for='username'><g:message code="springSecurity.login.username.label"/>:</label>

                <div class="controls">
				    <input type='text' class='text_' name='j_username' id='username'/>
                </div>
			</div>

            <div class="control-group">
				<label class="control-label" for='password'><g:message code="springSecurity.login.password.label"/>:</label>

                <div class="controls">
				<input type='password' class='text_' name='j_password' id='password'/>
                </div>
			</div>

            <div class="control-group" id="remember_me_holder">
                <div class="controls">
                    <label class="checkbox">
                        <input type='checkbox' class='chk' name='${rememberMeParameter}'
                               id='remember_me' <g:if test='${hasCookie}'>checked='checked'</g:if>/>
                        <g:message code="springSecurity.login.remember.me.label"/>
                    </label>
                </div>
            </div>

            <div class="form-actions">
                <button class="btn btn-primary" type="submit"
                        id="submit">${message(code: "springSecurity.login.button")}</button>
            </div>
		</form>
	</div>
</div></div>
<script type='text/javascript'>
	<!--
	(function() {
		document.forms['loginForm'].elements['j_username'].focus();
	})();
	// -->
</script>
</body>
</html>
