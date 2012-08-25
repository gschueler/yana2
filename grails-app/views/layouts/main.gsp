<!DOCTYPE html>
<html>
<head>
    <title>YANA <g:layoutTitle default="Welcome"/></title>
    %{--<link rel="stylesheet" href="${resource(dir:'css',file:'yana.css')}" />--}%
    %{--<g:render template="/common/css"/>--}%
    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}?v=2"/>
    <g:javascript library="jquery" plugin="jquery"/>
    <r:require module="jquery-ui"/>
    <r:require modules="bootstrap"/>

    <r:layoutResources/>
    <g:javascript src="jquery.json-2.3.js"/>
    <g:layoutHead/>


    <link rel="stylesheet" type="text/css" href="${resource(dir: 'css', file: 'superfish.css')}"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'hoverIntent.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'superfish.js')}"></script>

    <script type="text/javascript">
        // initialise plugins
        jQuery(function () {
            jQuery('ul.sf-menu').superfish();
        });
    </script>


    <script type="text/javascript">
        $(document).ready(function () {
            $('ul.sf-menu').superfish({
                                          delay:250, // one second delay on mouseout
                                          animation:{opacity:'show', height:'show'}, // fade-in and slide-down animation
                                          speed:'fast', // faster animation speed
                                          autoArrows:false, // disable generation of arrow mark-up
                                          dropShadows:false                            // disable drop shadows
                                      });
        });

    </script>

</head>

    <body>

        <g:render template="/common/header"/>

    <div class="container-fluid">
        <div id="body" class="row-fluid">

            <div class="span12">
                <!--Sidebar content-->
            %{--</div>--}%

            %{--<div class="span10">--}%
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