<form action="${createLink(action: 'saveAnswer')}" method="POST" autocomplete="off" id="answerForm">
    <input type="hidden" name="examSheet" value="${examSheet.id}"/>
    <input type="hidden" name="question" value="${answer.id}"/>

    <div class="answerSheet">
        <g:render template="answer/${question?.toString()?.split(':')?.find()?.split('\\.')?.last()?.trim()}"
                  model="${[question: question]}"/>
    </div>

    <div class="toolbar" style="margin-top:30px">
        <g:if test="${currentQuestion > 1}">
            <a href="${createLink(controller: 'exam', action: 'previous', id: examSheet.id)}"
               class="k-button">Previous</a>
        </g:if>
        <g:if test="${currentQuestion < totalQuestions}">
            <a href="${createLink(controller: 'exam', action: 'next', id: examSheet.id)}" class="k-button">Next</a>
        </g:if>
        <input type="submit" name="submit" class="k-button k-primary" value="Submit Answer" style="float:left"/>
    </div>
</form>
<script language="JavaScript" type="text/javascript">

    function validateForm(e) {
        var valid = internalValidate();
        console.log(valid);
        if (!valid) {
            e.preventDefault();
            $('#validatorMessage').slideDown();
            return false;
        } else {
            $('#validatorMessage').hide();
            return true;
        }
    }

    $(document).ready(function(e){
        $('#answerForm').submit(function(e){
            validateForm(e);
        });
    })
</script>