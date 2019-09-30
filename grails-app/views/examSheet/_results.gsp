<div class="total-points-container">
    <table style="width: 100%;" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <div id="chart" style="width: 100%;"></div>

            </td>
            <td class="total-points">
                <p>

                    <span><b class="big">%${Math.round(examSheet.markedMark * 100 / examSheet.markedScore)}</b></span>
                </p>

                <p>Total Points

                    <span><b class="medium">${examSheet.markedMark}</b> / ${examSheet.markedScore}
                    </span></p>

            </td>
        </tr>
    </table>
</div>
<table style="width: 100%;" cellpadding="0" cellspacing="0" class="topic-scores">
    <tr>
        <th>
            Topic
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
    <g:each in="${topicScores?.sort { -(it.value.mark * 100 / it.value.score) }}" var="topicScore" status="index">
        <tr class="${index % 2 ? 'even' : 'odd'}">
            <td>
                <b>${topicScore.key}</b>
            </td>
            <td>
                <b>${topicScore.value.correctAnswers}</b>
            </td>
            <td>
                ${topicScore.value.wrongAnswers}
            </td>
            <td>
                ${topicScore.value.skipped}
            </td>
            <td>
                <b>${topicScore.value.mark}</b>
            </td>
            <td>
                ${topicScore.value.score}
            </td>
            <td>
                <b>%${Math.round(topicScore.value.mark * 100 / topicScore.value.score)}</b>
            </td>
        </tr>
    </g:each>
</table>

<script>
    function createChart() {
        $("#chart").kendoChart({
            title: {
                position: "bottom",
                text: "Marked Questions"
            },
            legend: {
                visible: false
            },
            chartArea: {
                background: ""
            },
            seriesDefaults: {
                type: "donut",
                startAngle: 150
            },
            theme: 'metro',
            series: [{
                name: "2011",
                data: [{
                    category: "Incorrect",
                    value: ${examSheet.incorrectList?.size()},
                    color: "#E91E63"
                }, {
                    category: "Correct",
                    value: ${examSheet.correctList?.size()},
                    color: "#43A047"
                }, {
                    category: "Not Answered",
                    value: ${examSheet.unAnsweredList?.size()},
                    color: "#607D8B"
                }, {
                    category: "Not Marked",
                    value: ${examSheet.unMarkedList?.size()},
                    color: "#03A9F4"
                }],
                labels: {
                    visible: true,
                    background: "transparent",
                    position: "outsideEnd",
                    template: "#= category #: \n #= value#"
                }
            }],
            tooltip: {
                visible: true,
                template: "#= category #: #= value #"
            }
        });
    }

    $(document).ready(createChart);
    $(document).bind("kendo:skinChange", createChart);
</script>