
<form>
    <div class="answerSheet">
        <g:render template="answer/${question?.toString()?.split(':')?.find()?.split('\\.')?.last()?.trim()}" model="${[question: question]}"/>
    </div>

    <div class="toolbar">
        <input type="submit" class="k-button" value="Submit"/>
    </div>
</form>