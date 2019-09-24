<%@ page import="codxam.questions.QuestionChoice" %>

<h2 class="multiple-choice-title">
    Choose the correct answer:
</h2>
<span class="k-widget k-tooltip k-tooltip-validation k-invalid-msg" style="display: none" data-for="answer" role="alert" id="validatorMessage"><span class="k-icon k-i-warning"> </span> Please choose the correct answer first.</span>
<g:each in="${QuestionChoice.findAllByQuestionAndDeleted(question, false)?.sort { it.displayOrder }}" var="choice">
    <div class="option">
        <input type="radio" id="choice_${choice?.id}" value="${choice?.id}" name="answer" class="k-radio"/>
        <label class="k-radio-label no-margin" for="choice_${choice?.id}">&#8203;</label>
        <label for="choice_${choice?.id}">${choice.name}</label>
    </div>
</g:each>
<script language="JavaScript">

    function internalValidate(){
        return $(".option").find("[type=radio][name=answer]").is(":checked");
    }

</script>