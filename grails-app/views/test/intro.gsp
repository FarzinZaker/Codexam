<%--
  Created by IntelliJ IDEA.
  User: root
  Date: 8/14/14
  Time: 4:48 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="empty"/>
    <title>Test: ${examTemplate?.name}</title>
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

    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-6 col-xl-6 intro">
            <div>
                <p>
                    Congradulations! You have been invited to take an online test designed by Aclate for
                </p>

                <h2>${examTemplate?.name}</h2>

                <p>Please consider that only candidates who complete the next two following steps will be invited for interview:</p>
                <ol>
                    <li>
                        Submit the application form
                    </li>
                    <li>
                        Take the online test designed for the role that you applied for
                    </li>
                </ol>

                <div class="note">
                    <p>
                        Before you continue with the application, please feel free to visit the
                        <a href="https://www.aclate.com" target="_blank">Aclate website</a>
                        for more information regarding the company.
                    </p>

                    %{--<p>--}%
                    %{--Here are some of our products:--}%
                    %{--</p>--}%
                    %{--<ul>--}%
                    %{--<li><a href="https://www.onescm.com/" target="_blank">OneSCM</a></li>--}%
                    %{--<li><a href="https://www.beckon.com/" target="_blank">Beckon</a></li>--}%
                    %{--<li><a href="http://www.northplains.com/" target="_blank">NorthPlains</a></li>--}%
                    %{--<li><a href="https://smsmasterminds.com/" target="_blank">SMS Masterminds</a></li>--}%
                    %{--</ul>--}%
                </div>
            </div>
        </div>

        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-6 col-xl-6 intro">
            <div>

                <h2>Are you ready?</h2>

                <p>Since this test includes technical questions, make sure that your working environment is ready before starting the test.</p>

                <div class="tool-bar">
                    <a href="${createLink(action: 'apply', id: params.id)}" class="k-button">Start Your Application</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>