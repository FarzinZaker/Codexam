<%@ page import="grails.converters.JSON; codxam.QuestionTopic" %>
<div class="k-edit-form-container manual-dialog">

    <form id="form_${params.id}" autocomplete="off">
        <input type="hidden" name="id" value="${params.id}"/>

        <div id="tabstrip">
            <ul>
                <li class="k-state-active">
                    General
                </li>
                <li>
                    Question Type
                </li>
                <li>
                    Properties
                </li>
            </ul>

            <div>
                <p>
                    <label for="title">Title</label>
                    <input type="text" class="k-textbox" name="title" id="title" style="width: 100%;" value="${question?.title}"/>
                </p>

                <p>
                    <label for="body">Body</label>
                    <span id="editorContainer">
                        <textarea type="text" class="k-textbox" name="body" id="body" style="width: 100%;height:300px;"><format:html value="${question?.body}"/></textarea>
                    </span>
                </p>

                <p>
                    <label for="timeLimit">Time Limit</label>
                    <input name="timeLimit" id="timeLimit" style="width: 100%;" value="${question?.timeLimit}"/>
                </p>

                <p>
                    <label for="score">Score</label>
                    <input name="score" id="score" style="width: 100%;" value="${question?.score}"/>
                </p>
            </div>

            <div>
                <p>
                    <label for="type">Type</label>
                    <input name="type" id="type" style="width:100%" value="${question?.class?.name}" ${params.id ? 'readonly' : ''}/>
                </p>

                <g:each in="${types}" var="type">
                    <div class="questionOptions" data-type="${type}">
                        <g:render template="${type?.split('\\.')?.last()}"/>
                    </div>
                </g:each>
            </div>

            <div>
                <p>
                    <label for="topics">Topics</label>
                    <input type="hidden" name="topics"/>
                    <select id="topics" style="width: 100%;"></select>
                </p>

                <p>
                    <label for="difficulty">Difficulty Level</label>
                    <input name="difficulty" id="difficulty" style="width: 100%;" value="${question?.difficulty?.id}"/>
                </p>
            </div>
        </div>
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

<script id="noDataTemplate" type="text/x-kendo-tmpl">
        # var value = instance.input.val(); #
        # var id = instance.element[0].id; #
        <div>
            No topic found. Do you want to add new Topic - '#: value #' ?
        </div>
        <br />
        <button class="k-button" onclick="addNewTopic('#: id #', '#: value #')" ontouchend="addNewTopic('#: id #', '#: value #')">Add new Topic</button>
    </script>

<script>
    var topics, topicsDataSource;
    (function () {
        $("#tabstrip").kendoTabStrip({
            animation: {
                open: {
                    effects: "fadeIn"
                }
            }
        });

        topicsDataSource = new kendo.data.DataSource({
            batch: true,
            transport: {
                read: {
                    url: "${createLink(controller: 'topic', action: 'listSimple')}",
                    dataType: "json"
                },
                create: {
                    url: "${createLink(controller: 'topic', action: 'save')}",
                    dataType: "json"
                },
                parameterMap: function (options, operation) {
                    if (operation !== "read" && options.models) {
                        return {models: kendo.stringify(options.models)};
                    }
                }
            },
            schema: {
                model: {
                    id: "id",
                    fields: {
                        id: {type: "number"},
                        name: {type: "string"}
                    }
                }
            }
        });

        topics = $("#topics").kendoMultiSelect({
            placeholder: "Select topic",
            dataTextField: "name",
            dataValueField: "id",
            filter: "contains",
            autoBind: true,
            dataSource: topicsDataSource,
            noDataTemplate: $("#noDataTemplate").html()
        }).data("kendoMultiSelect");

        <g:if test="${question.id}">
        topics.value(${QuestionTopic.findAllByQuestion(question).collect{it.topic?.id} as JSON});
        </g:if>
        <g:else>
        topics.value(${[params.topic?.toLong()] as JSON});
        </g:else>

        if (tinymce.get("body"))
            tinymce.get("body").remove();

        tinymce.init({
            selector: 'textarea#body',
            height: 500,
            menubar: false,
            plugins: [
                'advlist autolink lists link image charmap print preview anchor',
                'searchreplace visualblocks code fullscreen image',
                'insertdatetime media table paste code help wordcount codesample code'
            ],
            codesample_languages: [
                {text: 'HTML/XML', value: 'markup'},
                {text: 'JavaScript', value: 'javascript'},
                {text: 'CSS', value: 'css'},
                {text: 'PHP', value: 'php'},
                {text: 'Ruby', value: 'ruby'},
                {text: 'Python', value: 'python'},
                {text: 'Java', value: 'java'},
                {text: 'C', value: 'c'},
                {text: 'C#', value: 'csharp'},
                {text: 'C++', value: 'cpp'}
            ],
            toolbar: 'undo redo formatselect bold italic backcolor alignleft aligncenter alignright alignjustify bullist numlist outdent indent removeformat image codesample code',
            content_css: [
                '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
                '//www.tiny.cloud/css/codepen.min.css'
            ],
            images_upload_url: '${createLink(controller: 'image', action:'upload')}'
        });

        $('.k-ct-cell.k-state-disabled').removeClass('k-state-disabled');

        $("#type").kendoComboBox({
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
            },
            change: questionTypeChanged
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

        $("#timeLimit").kendoNumericTextBox({
            format: "# Minutes",
            min: 1
        });

        $("#score").kendoNumericTextBox({
            format: "# Points",
            min: 1
        });

        questionTypeChanged();
    })();

    var lastHeight = 0;

    function resizeEditor() {
        var editor = $('#body').data("kendoEditor");
        var frame = editor.wrapper.find('iframe')[0];
        console.log($(frame.contentWindow.document).height());
        while (lastHeight === 0 || lastHeight != $(frame.contentWindow.document).height()) {
            frame.style.height = $(frame.contentWindow.document).height() + 'px';
            lastHeight = $(frame.contentWindow.document).height();
        }
    }


    function close() {
        wnd.close();
    }

    function save() {
        console.log(tinyMCE.get('body').getContent());
        $('input[name="topics"]').val(topics.value());
        $('textarea#body').html(tinyMCE.get('body').getContent());
        $.ajax({
            url: '${createLink(action:'save', id:params.id)}',
            data: $('#form_${params.id}').serialize(),
            method: 'POST'
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

    function questionTypeChanged() {
        $('.questionOptions').hide();
        $('.questionOptions[data-type="' + $('#type').val() + '"]').show();
    }

    function addNewTopic(widgetId, value) {
        $.ajax({
            url: '${createLink(controller:'topic', action:'save')}',
            data: {name: value},
            method: 'POST'
        }).done(function (response) {
            topicsDataSource.add({name: value, id: parseInt(response)});
        });

    }
</script>
