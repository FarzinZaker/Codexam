<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>${examTemplate.name}: Applicants</title>
</head>

<body>
<h1>${examTemplate.name}: Applicants</h1>

<div id="grid"></div>

<div id="form"></div>

<script type="text/x-kendo-template" id="toolbarTemplate">
<div class="refreshBtnContainer">
    <a href="\\#" class="k-return k-link k-button" title="Back" style="float: right;"><span
            class="k-icon k-i-arrow-left"></span>&nbsp;Return to Exam Templates</a></div>
</script>

<script>
    var grid, dataSource;
    $(document).ready(function () {
        dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url: '${createLink(action:'listJSON', id: params.id)}',
                    dataType: "json"
                },
                destroy: {
                    url: '${createLink(action:'delete')}',
                    dataType: "json"
                },
                parameterMap: function (options, operation) {
                    if (operation !== "read" && options.models) {
                        return {id: kendo.stringify(options.models)};
                    }
                }
            },
            batch: true,
            pageSize: 10,
            serverPaging: false,
            schema: {
                data: 'data',
                total: 'total',
                model: {
                    id: "id",
                    fields: {
                        id: {editable: false, nullable: false},
                        rank: {validation: {required: true}},
                        name: {validation: {required: true}},
                        country: {validation: {required: true}},
                        score: {validation: {required: true}},
                        notMarked: {validation: {required: true}},
                        endDate: {type: 'date', editable: false, nullable: false}
                    }
                }
            }
        });

        grid = $("#grid").kendoGrid({
            dataSource: dataSource,
            pageable: true,
            toolbar: kendo.template($("#toolbarTemplate").html()),
            columns: [
                {field: "rank", title: "Rank", width: "80px"},
                {field: "name", title: "Name"},
                {field: "country", title: "Country"},
                {field: "endDate", title: "Date", format: "{0:MM/dd/yyyy}"},
                {field: "score", title: "Score", width: "150px"},
                {
                    template: "#if (notMarked > 0) {# <a class=\'k-button\' href=\'${createLink(controller:'mark', action: 'it')}/#:id#\'>Mark (#:notMarked#)</a> #}#",
                    field: "id",
                    title: "Mark",
                    width: "160px"
                },
                {
                    command: [{text: "Details", click: viewDetails}, {
                        name: "deleteApplicant",
                        text: "Delete",
                        click: deleteApplicant
                    }], title: " ", width: "260px"
                }
            ],
            editable: "popup"
        });

        grid.find(".k-grid-toolbar").on("click", ".k-return", function (e) {
            e.preventDefault();
            window.location.href = "${createLink(controller:'examTemplate', action: 'list')}";
        });
    });

    function deleteApplicant(e) {
        e.preventDefault();

        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        $.ajax({
            url: '${createLink(action:'delete')}/' + dataItem.id
        }).done(function (response) {
            dataSource.read();
        });
    }

    function viewDetails(e) {
        e.preventDefault();

        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        window.location.href = "${createLink(controller: 'examSheet', action: 'details')}/" + dataItem.id;
    }

    function markQuestions(e) {
        e.preventDefault();

        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        window.location.href = "${createLink(controller: 'mark', action: 'it')}/" + dataItem.id;
    }
</script>

</body>
</html>
