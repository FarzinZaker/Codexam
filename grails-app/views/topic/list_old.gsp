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
                    url: '${createLink(action:'listJSON')}',
                    dataType: "json",
                    type: "POST"
                }
            },
            schema: {
                model: {
                    id: "id",
                    parentId: "parentId",
                    fields: {
                        id: {field: "id", type: 'number', nullable: false},
                        parentId: {field: "parentId", nullable: true}
                    }
                },
                expanded: true
            }
        });

        grid = $("#grid").kendoTreeList({
            dataSource: dataSource,
            pageable: true,
            toolbar: kendo.template($("#toolbarTemplate").html()),
            columns: [
                {field: "name", title: "Name"},
                {command: [{text: "Edit", click: editTopic}, "destroy"], title: " ", width: "230px"}
            ],
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
</script>

</body>
</html>
