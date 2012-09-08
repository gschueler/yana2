<!DOCTYPE html>
<html>
<head>
    <title>YANA <g:layoutTitle default="Welcome"/></title>
    %{--<g:render template="/common/css"/>--}%
    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}?v=2"/>
    <g:javascript library="jquery" plugin="jquery"/>
    <r:require module="jquery-ui"/>
    <r:require module="custom-bootstrap"/>
    <link rel="stylesheet" href="${resource(dir:'css',file:'base.css')}" />

    <r:layoutResources/>
    <g:javascript src="jquery.json-2.3.js"/>
    <g:layoutHead/>

</head>

    <body>

        <g:render template="/common/header"/>

    <div class="container-fluid">
        <div id="body" class="row-fluid">

            <div class="span12">
            <g:layoutBody/>
            </div>
        </div>

    </div>
        <div id="footer" class="row-fluid">
            <g:render template="/common/footer"/>
        </div>


    <r:layoutResources/>
    </body>
</html>