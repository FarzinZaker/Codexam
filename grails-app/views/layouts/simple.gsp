<!doctype html>
<html lang="en" class="no-js">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>
        <g:layoutTitle default="Grails"/>
    </title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <asset:link rel="icon" href="favicon.ico" type="image/x-ico"/>

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <asset:stylesheet src="grid-system.css"/>

    <asset:stylesheet src="styles/kendo.common.min.css"/>
    <asset:stylesheet src="styles/kendo.common-material.min.css"/>
    <asset:stylesheet src="styles/kendo.material.min.css"/>
    <asset:stylesheet src="styles/kendo.material.mobile.min.css"/>

    <asset:stylesheet src="theme.less"/>

    <asset:javascript src="js/jquery.min.js"/>
    <asset:javascript src="js/jszip.min.js"/>
    <asset:javascript src="js/kendo.all.min.js"/>

    <g:layoutHead/>
</head>

<body>

<div class="container">
    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
            <div class="header">
                <div>
                    <span class="big-logo">
                        <asset:image src="aclate.png"/>
                        <span>
                            CODXAM
                        </span>
                    </span>
                </div>
            </div>
        </div>
    </div>
    <g:layoutBody/>
    <g:render template="/layouts/footer"/>
</div>

<div id="spinner" class="spinner" style="display:none;">
    <g:message code="spinner.alt" default="Loading&hellip;"/>
</div>

<asset:javascript src="application.js"/>

</body>
</html>
