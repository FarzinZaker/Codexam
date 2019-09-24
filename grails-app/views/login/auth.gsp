<html>
<head>
    <meta name="layout" content="simple"/>
    <title><g:message code='springSecurity.login.title'/></title>
</head>

<body>
<h1><g:message code='springSecurity.login.header'/></h1>
<g:if test='${flash.message}'>
    <div class="error">${flash.message}</div>
</g:if>

<form action="${postUrl ?: '/login/authenticate'}" method="POST" id="loginForm" class="cssform" autocomplete="off">
    <p>
        <label for="username"><g:message code='springSecurity.login.username.label'/></label>
        <input type="text" class="text_ k-textbox" name="${usernameParameter ?: 'username'}" id="username"/>
    </p>

    <p>
        <label for="password"><g:message code='springSecurity.login.password.label'/></label>
        <input type="password" class="text_ k-textbox" name="${passwordParameter ?: 'password'}" id="password"/>
    </p>

    <p id="remember_me_holder">
        <label for="remember_me"><g:message code='springSecurity.login.remember.me.label'/></label>
        <input type="checkbox" class="chk" name="${rememberMeParameter ?: 'remember-me'}" id="remember_me" <g:if test='${hasCookie}'>checked="checked"</g:if>/>
    </p>

    <p>
        <input type="submit" id="submit" class="k-button" value="${message(code: 'springSecurity.login.button')}"/>
    </p>
</form>
<script>
    (function () {
        document.forms['loginForm'].elements['${usernameParameter ?: 'username'}'].focus();
        $("#remember_me").kendoSwitch({
            messages: {
                checked: "YES",
                unchecked: "NO"
            }
        });
    })();
</script>
</body>