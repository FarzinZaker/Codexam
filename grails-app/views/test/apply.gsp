<%--
  Created by IntelliJ IDEA.
  User: root
  Date: 8/14/14
  Time: 4:48 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="test"/>
    <title>Apply for ${examTemplate?.name}</title>
</head>

<body>
<div class="container">
    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">

            <h1>Apply for ${examTemplate?.name}</h1>

            <form action="${createLink(action: 'saveApplication')}" method="POST" autocomplete="off">
                <p>
                    <label for="firstName">First Name</label>
                    <input type="text" class="k-textbox" name="firstName" id="firstName"/>
                </p>

                <p>
                    <label for="lastName">Last Name</label>
                    <input type="text" class="k-textbox" name="lastName" id="lastName"/>
                </p>

                <p>
                    <label for="email">Email Address</label>
                    <input type="text" class="k-textbox" name="email" id="email"/>
                </p>

                <p>
                    <label for="skypeID">Skype ID</label>
                    <input type="text" class="k-textbox" name="skypeID" id="skypeID"/>
                </p>

                <p>
                    <label for="country">Country of residence</label>
                    <g:render template="/controls/countrySelector"/>
                </p>

                <p>
                    <label for="timeZone">Time Zone</label>
                    <input type="text" class="k-textbox" name="timeZone" id="timeZone"/>
                </p>

                <p>
                    <label for="cv">CV</label>
                    <input type="text" class="k-textbox" name="cv" id="cv"/>
                </p>

                <p>
                    <input type="submit" id="submit" class="k-button" value="APPLY"/>
                </p>
            </form>
        </div>
    </div>
</div>
</body>
</html>