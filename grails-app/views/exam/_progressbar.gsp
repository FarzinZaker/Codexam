<table class="progress-bar">
    <tr>
        <g:each in="${(1..total)}" var="index">
            <td class="${index < current ? 'done' : index == current ? 'current' : 'pending'}" style="width:${100 / total}%">
                <g:if test="${index == current}">
                    <b>${current}</b> / ${total}
                </g:if>
            </td>
        </g:each>
    </tr>
</table>