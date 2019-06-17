<%@ page import="codxam.questions.QuestionChoice" %>

<p class="multiple-choice-title">
    Choose the correct answer:
</p>
<g:each in="${QuestionChoice.findAllByQuestionAndDeleted(question, false)?.sort { it.displayOrder }}" var="choice">
    <div class="option">
        <input type="radio" id="choice_${choice?.id}" value="${choice?.id}" name="answer" class="k-radio"/>
        <label class="k-radio-label no-margin" for="choice_${choice?.id}">&#8203;</label>
        <label for="choice_${choice?.id}">${choice.name}</label>
    </div>
</g:each>