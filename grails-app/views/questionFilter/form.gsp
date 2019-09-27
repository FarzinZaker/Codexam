<div class="k-edit-form-container manual-dialog">

    <form id="form_${params.id}" autocomplete="off">
        <input type="hidden" name="id" value="${questionFilter.id}"/>
        <input type="hidden" name="examTemplate.id" value="${questionFilter?.examTemplate?.id}"/>

        <p>
            <label for="topic">Topic</label>
            <g:render template="/topic/selector"
                      model="${[name: 'topic.id', id: 'topic', value: questionFilter?.topic?.id, style: 'width: 570px;']}"/>
        </p>
        <p>
            <label for="questionType">Type</label>
            <input name="questionType" id="questionType" style="width:570px;" value="${questionFilter?.questionType}"/>
        </p>

        <p>
            <label for="difficulty">Difficulty Level</label>
            <input name="difficulty" id="difficulty" style="width: 570px;" value="${questionFilter?.difficulty?.id}"/>
        </p>

        <p>
            <label for="maxTime">Maximum Time</label>
            <input name="maxTime" id="maxTime" style="width: 570px;" value="${questionFilter?.maxTime}"/>
        </p>

        <p>
            <label for="count">Count</label>
            <input name="count" id="count" style="width: 570px;" value="${questionFilter?.count}"/>
        </p>
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

        $("#questionType").kendoComboBox({
            placeholder: "Select Type",
            dataTextField: "name",
            dataValueField: "id",
            filter: "contains",
            autoBind: true,
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'question', action: 'listAnswerTypes')}",
                        dataType: "json"
                    }
                }
            }
        });

        $("#difficulty").kendoComboBox({
            placeholder: "Select difficulty level",
            dataTextField: "name",
            dataValueField: "id",
            filter: "contains",
            autoBind: true,
            dataSource: {
                transport: {
                    read: {
                        url: "${createLink(controller: 'difficulty', action: 'listSimple')}",
                        dataType: "json"
                    }
                }
            }
        });

        $("#count, #maxTime").kendoNumericTextBox({
            format: "#",
            min: 1
        });
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
</script>
