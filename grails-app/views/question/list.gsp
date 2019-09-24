<%--
  Created by IntelliJ IDEA.
  User: root
  Date: 8/14/14
  Time: 4:48 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title><g:message code="${topic?.name}"/> Question</title>
</head>

<body>
<asset:javascript src="tinymce.min.js"/>
<h1><g:message code="${topic?.name}"/> Questions</h1>

<div id="grid"></div>

<div id="form"></div>

<script type="text/x-kendo-template" id="toolbarTemplate">
<div class="refreshBtnContainer">
    <a href="\\#" class="k-add k-link k-button" title="New"><span class="k-icon k-i-plus"></span> New Question</a>
</div>
</script>
<script>
    var wnd, grid, dataSource;
    $(document).ready(function () {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: '${createLink(action:'listJSON', id:params.id)}',
                    dataType: "json"
                },
                update: {
                    url: '${createLink(action:'save')}',
                    dataType: "json"
                },
                destroy: {
                    url: '${createLink(action:'delete')}',
                    dataType: "json"
                },
                create: {
                    url: '${createLink(action:'save', id: params.id)}',
                    dataType: "json"
                },
                parameterMap: function (options, operation) {
                    if (operation !== "read" && options.models) {
                        return {models: kendo.stringify(options.models)};
                    }
                }
            },
            batch: true,
            pageSize: 10,
            schema: {
                data: 'data',
                total: 'total',
                model: {
                    id: "id",
                    fields: {
                        title: {type: "string", validation: {required: true}},
                        topic: {type: "string", validation: {required: true}},
                        difficulty: {type: "string", validation: {required: true}},
                        type: {type: "string", validation: {required: true}},
                        timeLimit: {type: "integer", validation: {required: true}},
                        score: {type: "integer", validation: {required: true}},
                        dateCreated: {type: "date", editable: false, nullable: false},
                        lastUpdated: {type: "date", editable: false, nullable: false}
                    }
                }
            }
        });

        grid = $("#grid").kendoGrid({
            dataSource: dataSource,
            pageable: true,
            toolbar: kendo.template($("#toolbarTemplate").html()),
            columns: [
                {field: "title", title: "Title"},
                {field: "difficulty", title: "Diffuculty", width: "100px"},
                {field: "type", title: "Type", width: "160px"},
                {field: "timeLimit", title: "Time Limit", width: "110px"},
                {field: "score", title: "Score", width: "80px"},
                // {field: "topics", title: "Topics", width: "100px"},
                // {field: "dateCreated", title: "Created", format: "{0:MM/dd/yyyy h:mm tt}"},
                // {field: "lastUpdated", title: "Updated", format: "{0:MM/dd/yyyy h:mm tt}"},
                {command: [{text: "Edit", click: editQuestion}, "destroy"], title: " ", width: "230px"}
            ],
            editable: "popup",
            edit: function (e) {
                $(e.container).find('input[type="checkbox"]').addClass('k-checkbox');
            }
        });

        wnd = $("#form")
            .kendoWindow({
                title: "Question Form",
                modal: true,
                visible: false,
                resizable: false,
                actions: ["Maximize", "Close"],
                width: 850
            }).data("kendoWindow");

        grid.find(".k-grid-toolbar").on("click", ".k-add", function (e) {
            e.preventDefault();
            kendo.ui.progress(wnd.element, true);
            wnd.refresh({
                url: '${createLink(action:'form')}',
                data: {topic: ${params.id}}
            });
            wnd.bind("refresh", function () {
                wnd.center();
                wnd.open();
            });
            wnd.title('New Question').center().open();
        });

    });

    function editQuestion(e) {
        e.preventDefault();
        kendo.ui.progress(wnd.element, true);
        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        wnd.refresh({
            url: '${createLink(action:'form')}',
            data: {id: dataItem.id}
        });
        wnd.bind("refresh", function () {
            wnd.center();
            wnd.open();
        });
        wnd.title('Edit Question').center().open();
    }
</script>
</body>
</html>