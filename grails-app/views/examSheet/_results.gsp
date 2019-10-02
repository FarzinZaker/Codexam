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

<div id="detailsTabstript" style="margin-right: -15px;margin-left:-15px;">
    <ul>
        <li class="k-state-active">
            Topics
        </li>
        <li>
            Difficulty Levels
        </li>
        <li>
            Question Types
        </li>
    </ul>

    <div>
        <g:render template="resultsDetails" model="${[scores: topicScores, title: 'Topic']}"/>
    </div>

    <div>
        <g:render template="resultsDetails" model="${[scores: difficultyScores, title: 'Difficulty Level']}"/>
    </div>

    <div>
        <g:render template="resultsDetails" model="${[scores: questionTypeScores, title: 'Question Type']}"/>
    </div>
</div>
<script>
    $(document).ready(function () {
        $("#detailsTabstript").kendoTabStrip({
            animation: {
                open: {
                    effects: "fadeIn"
                }
            }
        });
    });

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