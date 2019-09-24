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
    <title>${question?.title}</title>
    <asset:stylesheet src="styles/a11y-light.css"/>
    <asset:stylesheet src="flipclock.css"/>
    <asset:javascript src="highlight.pack.js"/>
    <asset:javascript src="flipclock.js"/>
</head>

<body>

<div class="container-fluid">
    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
            <div class="info-bar">
                <div class="container">
                    <div class="row">
                        <div class="col-xs-12 col-sm-12 col-md-8 col-lg-9 col-xl-10">
                            <g:render template="progressbar"
                                      model="${[total: totalQuestions, current: currentQuestion]}"/>
                        </div>

                        <div class="col-xs-12 col-sm-12 col-md-4 col-lg-3 col-xl-2">
                            <g:render template="countDown" model="${[timeLimit: question.timeLimit]}"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <div class="row">

        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
            <h1>${question.title}</h1>

            <div class="question">
                <format:html value="${question?.body}"/>
            </div>
            <g:render template="answerForm" model="${[question: question]}"/>
        </div>
    </div>
</div>
<script>
    hljs.initHighlightingOnLoad();
</script>
</body>
</html>