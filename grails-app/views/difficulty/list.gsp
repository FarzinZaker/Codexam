<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Difficulty Levels</title>
</head>

<body>
<h1>Difficulty Levels</h1>

<div id="grid"></div>

<div id="form"></div>

<script type="text/x-kendo-template" id="toolbarTemplate">
<div class="refreshBtnContainer">
    <a href="\\#" class="k-add k-link k-button" title="New"><span class="k-icon k-i-plus"></span> New Difficulty Level</a>
</div>
</script>

<script>
    var grid, wnd, dataSource;
    $(document).ready(function () {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: '${createLink(action:'listJSON')}',
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
                    if (operation !== "read" && options.models) {
                        return {models: kendo.stringify(options.models)};
                    }
                }
            },
            batch: true,
            pageSize: 10,
            serverPaging: true,
            schema: {
                data: 'data',
                total: 'total',
                model: {
                    id: "id",
                    fields: {
                        id: {editable: false, nullable: false},
                        name: {validation: {required: true}},
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
                {command: [{text: "Edit", click: editDifficulty}, "destroy"], title: " ", width: "220px"}
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
            wnd.title('New Difficulty Level').center().open();
        });

        wnd = $("#form")
            .kendoWindow({
                title: "Difficulty Level Form",
                modal: true,
                visible: false,
                resizable: false,
                width: 600
            }).data("kendoWindow");
    });

    function editDifficulty(e) {
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
        wnd.title('Edit Difficulty Level').center().open();
    }
</script>

</body>
</html>
