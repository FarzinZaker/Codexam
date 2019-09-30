<div class="progress-bar marking">
    <div>
        <b>Question ${current}</b> out of ${total}
    </div>
    <table>
        <tr>
            <g:each in="${answers}" var="answer" status="i">
                <td class="${i + 1 == current ? 'current' : answer.mark ? 'done' : 'pending'}"
                    style="width:${100 / total}%" onclick="showQuestion(${i + 1})">
                    ${answer.sequence}
                </td>
            </g:each>
        </tr>
    </table>
</div>
<script language="JavaScript">
    function showQuestion(index) {
        window.location.href = "${createLink(controller: 'mark', action: 'it', id: params.id)}?question=" + index;
    }
</script>