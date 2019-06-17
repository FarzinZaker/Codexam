<div class="k-edit-form-container manual-dialog">

    <form id="form_${params.id}" autocomplete="off">
        <input type="hidden" name="id" value="${params.id}"/>

        <p>
            <label for="name">Name</label>
            <input type="text" class="k-textbox" name="name" id="name" style="width: 570px;" value="${examTemplate?.name}"/>
        </p>

        <p>
            <label for="type">Type</label>
            <input name="type" id="type" style="width: 570px;" value="${examTemplate?.class?.name}" ${params.id ? 'readonly' : ''}/>
        </p>

        <g:each in="${types}" var="type">
            <div class="examTemplateOptions" data-type="${type}">
                <g:render template="${type?.split('\\.')?.last()}"/>
            </div>
        </g:each>
    </form>

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
    (function () {

        $("#type").kendoComboBox({
            placeholder: "Select Type",
            dataTextField: "name",
            dataValueField: "id",
            filter: "contains",
            autoBind: true,
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'examTemplate', action: 'listAnswerTypes')}",
                        dataType: "json"
                    }
                }
            },
            change: examTemplateTypeChanged
        });

        examTemplateTypeChanged();
    })();

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

    function examTemplateTypeChanged() {
        $('.examTemplateOptions').hide();
        $('.examTemplateOptions[data-type="' + $('#type').val() + '"]').show();
    }
</script>
