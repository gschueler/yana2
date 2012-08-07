<!doctype html>
<html>
	<head>
		<title><g:message code="page.not.found.title"/></title>
		<meta name="layout" content="main">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'errors.css')}" type="text/css">
	</head>
	<body>
    <h1><g:message code="page.not.found.title"/></h1>

    <div class='errors'>
    <g:if test="${message}">
        ${message.encodeAsHTML()}
    </g:if>
    <g:else>
        <g:message code="page.not.found.message"/>
    </g:else>
    </div>

	</body>
</html>