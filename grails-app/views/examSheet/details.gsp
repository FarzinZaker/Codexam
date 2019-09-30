<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>${examSheet.applicant?.firstName} ${examSheet.applicant?.lastName}: ${examSheet.examTemplate?.name}</title>
</head>

<body>
<h1>${examSheet.applicant?.firstName} ${examSheet.applicant?.lastName}: ${examSheet.examTemplate?.name}</h1>

<div id="tabstrip">
    <ul>
        <li class="k-state-active">
            Information
        </li>
        <li>
            Results
        </li>
    </ul>

    <div>
        <g:render template="applicant" model="${[applicant: examSheet.applicant]}"/>
    </div>

    <div>
        <g:render template="results" model="${[examSheet: examSheet, topicScores: topicScores]}"/>
    </div>
</div>
<script>
    $(document).ready(function () {
        $("#tabstrip").kendoTabStrip({
            animation: {
                open: {
                    effects: "fadeIn"
                }
            }
        });
    });
</script>

</body>
</html>
