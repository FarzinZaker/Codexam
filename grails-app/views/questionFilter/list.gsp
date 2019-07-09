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
    <title><g:message code="${examTemplate?.name}"/> Filters</title>
</head>

<body>
<h1><g:message code="${examTemplate?.name}"/> Filters</h1>

<div id="grid"></div>

<div id="form"></div>

<script type="text/x-kendo-template" id="toolbarTemplate">
<div class="refreshBtnContainer">
    <a href="\\#" class="k-add k-link k-button" title="New"><span class="k-icon k-i-plus"></span> New QuestionFilter Filter</a>
    <a href="\\#" class="k-return k-link k-button" title="Back" style="float: right;"><span class="k-icon k-i-arrow-left"></span> Return to Exam Templates</a>
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
            pageSize: 20,
            schema: {
                data: 'data',
                total: 'total',
                model: {
                    id: "id",
                    fields: {
                        topic: {type: "string", validation: {required: true}},
                        difficulty: {type: "string", validation: {required: true}},
                        count: {type: "integer", validation: {required: true}},
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
                {field: "topic", title: "Topic"},
                {field: "difficulty", title: "Diffuculty"},
                {field: "count", title: "Count"},
                // {field: "dateCreated", title: "Created", format: "{0:MM/dd/yyyy h:mm tt}"},
                // {field: "lastUpdated", title: "Updated", format: "{0:MM/dd/yyyy h:mm tt}"},
                {command: [{text: "Edit", click: editQuestionFilter}, "destroy"], title: " ", width: "230px"}
            ],
            editable: "popup",
            edit: function (e) {
                $(e.container).find('input[type="checkbox"]').addClass('k-checkbox');
            }
        });

        grid.find(".k-grid-toolbar").on("click", ".k-return", function (e) {
            e.preventDefault();
            window.location.href = "${createLink(controller:'examTemplate', action: 'list')}"
        });

        grid.find(".k-grid-toolbar").on("click", ".k-add", function (e) {
            e.preventDefault();
            kendo.ui.progress(wnd.element, true);
            wnd.refresh({
                url: '${createLink(action:'form')}',
                data: {examTemplate: ${params.id}}
            });
            wnd.bind("refresh", function () {
                wnd.center();
                wnd.open();
            });
            wnd.title('New Question Filter').center().open();
        });

        wnd = $("#form")
            .kendoWindow({
                title: "QuestionFilter Form",
                modal: true,
                visible: false,
                resizable: false,
                width: 600
            }).data("kendoWindow");

    });

    function editQuestionFilter(e) {
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
        wnd.title('Edit Question Filter').center().open();
    }
</script>
</body>
</html>