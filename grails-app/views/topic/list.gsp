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
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: '${createLink(action:'listJSON')}',
                    dataType: "json",
                    type: "POST"
                },
                update: {
                    url: '${createLink(action:'save')}',
                    dataType: "json",
                    type: "POST"
                },
                destroy: {
                    url: '${createLink(action:'delete')}',
                    dataType: "json",
                    type: "POST"
                },
                create: {
                    url: '${createLink(action:'save')}',
                    dataType: "json",
                    type: "POST"
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
                        id: {editable: false, nullable: false},
                        name: {validation: {required: true, unique: true}},
                        dateCreated: {type: 'date', editable: false, nullable: false},
                        lastUpdated: {type: 'date', editable: false, nullable: false}
                    }
                }
            }
        });

        grid = $("#grid").kendoGrid({
            dataSource: dataSource,
            pageable: true,
            toolbar: kendo.template($("#toolbarTemplate").html()),
            columns: [
                {field: "name", title: "Name"},
                // {field: "dateCreated", title: "Created", format: "{0:MM/dd/yyyy h:mm tt}"},
                // {field: "lastUpdated", title: "Updated", format: "{0:MM/dd/yyyy h:mm tt}"},
                {command: [{text: "Edit", click: editTopic}, "destroy"], title: " ", width: "220px"}
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
