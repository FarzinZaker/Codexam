<div class="k-edit-form-container manual-dialog">

    <h3>${topic.name}</h3>

    <form id="form_${params.id}" autocomplete="off">
        <input type="hidden" name="id" value="${topic?.id}"/>

        <p>
            <label for="parent">Move Questions To</label>
            <g:render template="selector"
                      model="${[name: 'parent.id', id: 'parent', style: 'width: 570px;']}"/>
        </p>
    </form>

    <g:if test="${suggestedTopics.size()}">
        <h4>Suggestions</h4>
        <ul class="option-list">
            <g:each in="${suggestedTopics?.sort { -it.value }}" var="suggestedTopic">
                <li onclick="chooseOption(${suggestedTopic.key.id});"><b
                        class="questions-flag">${suggestedTopic.value}</b> ${suggestedTopic.key.name}</li>
            </g:each>
        </ul>
    </g:if>

    <div class="modal-error error" id="saveError"></div>

    <div class="k-edit-buttons k-state-default">
        <a role="button" class="k-button k-button-icontext k-primary k-grid-update" href="javascript:save()">
            <span class="k-icon k-i-check"></span> Delete
        </a>
        <a role="button" class="k-button k-button-icontext k-grid-cancel" href="javascript:close()">
            <span class="k-icon k-i-cancel"></span>Cancel
        </a>
    </div>
</div>
<script>
    function close() {
        wnd.close()
    }

    function save() {
        $.ajax({
            url: '${createLink(action:'delete', id:params.id)}',
            data: $('#form_${params.id}').serialize()
        }).done(function (response) {
            if (response == '1') {
                $('#saveError').hide();
                close();
                dataSource.read();
            } else {
                $('#saveError').html(response).show();
            }
        });
    }

    function chooseOption(id) {
        $("#parent").data("kendoDropDownTree").value(id);
    }
</script>
