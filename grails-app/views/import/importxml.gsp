<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>Import</title>
    </head>
    <body>

        <div class="body">
            <g:if test="${flash.message}">
            <div class="alert">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${attributesInstance}">
            <div class="errors">
                <g:renderErrors bean="${attributesInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:uploadForm action="savexml" class="form-horizontal">
                <legend>Import XML</legend>
                        <div class="control-group">
                            <label class="control-label" for="project">Project</label>
                            <div class="controls">
                                <g:select name="project" from="${projectList}" optionKey="name"
                                                      optionValue="name" value="${session.project}"/>
                            </div>
                        </div>
                            <div class="control-group">
                                <label class="control-label" for="file">Import XML Source File</label>
                                <div class="controls">
                                <input type="file" name="yanaimport"/>
                                </div>
                            </div>
                        
                <div class="form-actions">
                    <g:submitButton name="import" class="btn btn-primary" value="import" />
                </div>
            </g:uploadForm>
        </div>
    </body>
</html>
