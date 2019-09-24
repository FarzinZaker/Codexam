<div class="k-edit-form-container manual-dialog">

    <form id="form_${params.id}" autocomplete="off">
        <input type="hidden" name="id" value="${topic?.id}"/>

        <p>
            <label for="name">Name</label>
            <input name="name" id="name" style="width: 570px;" value="${topic?.name}" class="k-textbox"/>
        </p>

        <p>
            <label for="parent">Parent</label>
            <g:render template="selector"
                      model="${[name: 'parent.id', id: 'parent', value: topic?.parent?.id, style: 'width: 570px;']}"/>
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
            <span class="k-icon k-i-check"></span>${params.id ? 'Update' : 'Save'}
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
            url: '${createLink(action:'save', id:params.id)}',
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
