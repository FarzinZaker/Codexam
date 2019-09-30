<%@ page import="codxam.QuestionTopic" %>
<div class="question-meta">
    <span class="metadata">
        <span class="k-icon k-i-question"></span>
        <g:each in="${QuestionTopic.findAllByQuestion(question)?.topic}" var="topic">
            <span class="tag">${topic.name}</span>
        </g:each>
    </span>
    <span class="metadata">
        <span class="k-icon k-i-check"></span> <span class="tag red">${question.score} Points</span>
    </span>
    <span class="metadata">
        <span class="k-icon k-i-bell"></span> <span class="tag green">${question.difficulty.name}</span>
    </span>
    <span class="metadata">
        <span class="k-icon k-i-clock"></span> <span class="tag orange">${question.timeLimit} Minutes</span>
    </span>
</div>