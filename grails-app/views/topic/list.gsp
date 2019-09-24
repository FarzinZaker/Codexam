<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Test Topics</title>
</head>

<body>
<h1>Test Topics</h1>

<div id="grid"></div>

<div id="form"></div>

<script type="text/x-kendo-template" id="toolbarTemplate">
<div class="refreshBtnContainer">
    <a href="\\#" class="k-add k-link k-button" title="New"><span class="k-icon k-i-plus"></span> New Test Topic</a>
</div>
</script>

<script>
    var grid, wnd, dataSource;
    $(document).ready(function () {

        dataSource = new kendo.data.TreeListDataSource({
            transport: {
                read: {
                    url: "${createLink(action:'listJSON')}",
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
                    url: '${createLink(action:'save')}',
                    dataType: "json"
                },
                parameterMap: function (options, operation) {
                    if (operation !== "read" && options.id) {
                        console.log(options.id);
                        return {id: options.id};
                    }
                }
            },
            schema: {
                data: 'data',
                total: 'total',
                model: {
                    id: "id",
                    parentId: "parentId",
                    fields: {
                        parentId: {field: "parentId", nullable: true},
                        name: {field: "name", type: "string"},
                        id: {field: "id", type: "number"}
                    }
                }
            }
        });
        grid = $("#grid").kendoTreeList({
            dataSource: dataSource,
            sortable: true,
            columns: [
                {field: "name", title: "Name"},
                {command: [{name: "customEdit", text: "Edit", click: editTopic}, {name: "addChildTopic", text: "Add Child", click: addChildTopic}, {name: "deleteTopic", text: "Delete", click: deleteTopic}], width: 360}
            ],
            pageable: true,
            toolbar: kendo.template($("#toolbarTemplate").html()),
            editable: "popup"
        });

        grid.find(".k-grid-toolbar").on("click", ".k-add", function (e) {
            e.preventDefault();
            kendo.ui.progress(wnd.element, true);
            wnd.refresh({
                url: '${createLink(action:'form')}'
            });
            wnd.bind("refresh", function () {
                wnd.center();
                wnd.open();
            });
            wnd.title('New Test Topic').center().open();
        });

        wnd = $("#form")
            .kendoWindow({
                title: "Test Topic Form",
                modal: true,
                visible: false,
                resizable: false,
                width: 600
            }).data("kendoWindow");
    });

    function editTopic(e) {
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
        wnd.title('Edit Test Topic').center().open();
    }

    function deleteTopic(e) {
        e.preventDefault();
        kendo.ui.progress(wnd.element, true);

        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        wnd.refresh({
            url: '${createLink(action:'deleteForm')}',
            data: {id: dataItem.id}
        });
        wnd.bind("refresh", function () {
            wnd.center();
            wnd.open();
        });
        wnd.title('Delete Test Topic').center().open();
    }

    function addChildTopic(e) {
        e.preventDefault();
        kendo.ui.progress(wnd.element, true);

        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        wnd.refresh({
            url: '${createLink(action:'form')}',
            data: {parentId: dataItem.id}
        });
        wnd.bind("refresh", function () {
            wnd.center();
            wnd.open();
        });
        wnd.title('Add Child Test Topic').center().open();
    }
</script>

</body>
</html>
