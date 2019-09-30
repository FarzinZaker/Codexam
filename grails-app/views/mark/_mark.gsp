<form action="${createLink(action: 'saveMark')}" method="POST" autocomplete="off" id="answerForm">
    <input type="hidden" name="examSheet" value="${examSheet.id}"/>
    <input type="hidden" name="question" value="${answer.id}"/>

    <div class="markPanel">
        <input type="number" name="mark" id="mark" value="${answer.mark ?: 0}"/>
    </div>

    <div class="toolbar" style="margin-top:30px">
        <g:if test="${currentQuestion > 1}">
            <a href="${createLink(controller: 'mark', action: 'previous', id: examSheet.id)}"
               class="k-button">Previous</a>
        </g:if>
        <g:if test="${currentQuestion < totalQuestions}">
            <a href="${createLink(controller: 'mark', action: 'next', id: examSheet.id)}" class="k-button">Next</a>
        </g:if>
        <a href="${createLink(controller: 'examSheet', action: 'list', id: examSheet.examTemplate.id)}"
           class="k-button">Cancel</a>

        <input type="submit" name="submit" class="k-button k-primary" value="Submit Mark" style="float:left"/>
    </div>
</form>
<script language="JavaScript" type="text/javascript">

    $(document).ready(function (e) {

        $("#mark").kendoNumericTextBox({
            format: "# Points",
            min: 0,
            max: ${question.score}
        });
    })
</script>