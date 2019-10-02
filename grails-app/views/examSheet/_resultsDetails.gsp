<div id="chart${title?.replace(' ', '_')}" style="width: 100%;"></div>
<script>

    $(document).ready(function () {
        $("#chart${title?.replace(' ', '_')}").kendoChart({
            title: {
                text: "${title}s"
            },
            legend: {
                visible: false
            },
            seriesDefaults: {
                type: "column"
            },
            theme: 'metro',
            series: [{
                name: "${title}",
                data: [<format:html value="${scores?.sort{it.key}?.collect{score -> Math.round(score.value.mark * 100 / (score.value.score ?: 1))?.toString()}?.join(', ')}"/>]
            }],
            valueAxis: {
                labels: {
                    format: "{0}%"
                },
                line: {
                    visible: false
                },
                axisCrossingValue: 0
            },
            categoryAxis: {
                categories: [<format:html value="${scores?.keySet()?.sort{it}?.collect{"'${it}'"}?.join(', ')}"/>],
                line: {
                    visible: false
                },
                <g:if test="${scores.size() > 5}">
                labels: {
                    rotation: -45
                }
                </g:if>
            },
            tooltip: {
                visible: true,
                format: "{0}%",
                template: "#= value #"
            }
        });
    });
</script>

<table style="width: 100%;" cellpadding="0" cellspacing="0" class="topic-scores">
    <tr>
        <th>
            ${title}
        </th>
        <th>
            Correct Answers
        </th>
        <th>
            Wrong Answers
        </th>
        <th>
            Skipped Questions
        </th>
        <th>
            Total Mark
        </th>
        <th>
            Total Possible Score
        </th>
        <th>
            Percentage
        </th>
    </tr>
    <g:each in="${scores?.findAll { it.value.score }?.sort { -(it.value.mark * 100 / (it.value.score ?: 1)) }}"
            var="score" status="index">
        <tr class="${index % 2 ? 'even' : 'odd'}">
            <td>
                <b>${score.key}</b>
            </td>
            <td>
                <b>${score.value.correctAnswers}</b>
            </td>
            <td>
                ${score.value.wrongAnswers}
            </td>
            <td>
                ${score.value.skipped}
            </td>
            <td>
                <b>${score.value.mark}</b>
            </td>
            <td>
                ${score.value.score}
            </td>
            <td>
                <b>%${Math.round(score.value.mark * 100 / (score.value.score ?: 1))}</b>
            </td>
        </tr>
    </g:each>
</table>