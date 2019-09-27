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
    <title>Test Results: ${examSheet?.examTemplate?.name}</title>
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
                    Congratulations ${examSheet?.applicant?.firstName}! You have finished the test for
                    <b>${examSheet?.examTemplate?.name}</b>
                    role.
                </p>

                <p>We have not marked all your answers yet, but here is what we know up to now about your results:</p>

                <div id="chart" style="width: 100%;"></div>

                <div class="note">
                    <p>
                        Our reviewers will mark remaining questions as soon as possible to calculate your final mark.
                    </p>
                </div>
            </div>
        </div>

        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-6 col-xl-6 intro">
            <div>
                <h2>Yout total score</h2>

                <p>Without considering not marked questions.</p>

                <div class="score">
                    <div class="big green">%${Math.round(examSheet.markedMark * 100 / examSheet.markedScore)}</div>

                    <div class="medium"><span class="blue">${examSheet.markedMark}</span> / ${examSheet.markedScore}
                    </div>
                </div>

                <h2>What next?</h2>

                <p>
                    After reviewing all you answers, applicants with <b>highest scores</b> will be invited for an online interview. We will use your provide email address (<a
                        href="mailto:${examSheet.applicant?.email}">${examSheet.applicant?.email}</a>) to communicate with you.
                </p>

                <p>So, <b>Keep in touch</b> please!</p>

            </div>
        </div>
    </div>
</div>
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
</body>
</html>