<div class="progress-bar">
    <div>
        <b>Question ${current}</b> out of ${total}
    </div>
    <table>
        <tr>
            <g:each in="${answers}" var="answer">
                <td class="${answer.sequence == current ? 'current' : answer.answered ? 'done' : 'pending'}"
                    style="width:${100 / total}%" onclick="showQuestion(${answer.sequence})">
                    ${answer.sequence}
                </td>
            </g:each>
        </tr>
    </table>
</div>
<script language="JavaScript">
    function showQuestion(index) {
        window.location.href = "${createLink(controller: 'exam', action: 'take', id: params.id)}?question=" + index;
    }
</script>