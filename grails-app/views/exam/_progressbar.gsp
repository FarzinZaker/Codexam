<div class="progress-bar">
    <div>
        <b>Question ${current}</b> out of ${total}
    </div>
    <table>
        <tr>
            <g:each in="${(1..total)}" var="index">
                <td class="${index < current ? 'done' : index == current ? 'current' : 'pending'}"
                    style="width:${100 / total}%" onclick="showQuestion(${index})">
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