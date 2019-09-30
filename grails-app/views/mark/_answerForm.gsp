<div class="answerSheet">
    <g:render template="answer/${question?.toString()?.split(':')?.find()?.split('\\.')?.last()?.trim()}"
              model="${[question: question]}"/>
</div>
