<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>Import</title>
    </head>
    <body>
        <div class="body">
            <h1>XML Import</h1>
            <g:if test="${flash.message}">
            <div class="alert">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${attributesInstance}">
            <div class="errors">
                <g:renderErrors bean="${attributesInstance}" as="list" />
            </div>
            </g:hasErrors>
            <div class="alert alert-success">
                Your import has successfully finished!
            </div>
            <div class="hero-unit">
                <p>
                    <g:link controller="node" action="list"
                            class="btn btn-primary btn-large">View Nodes</g:link>
                </p>
            </div>

        </div>
    </body>
</html>
