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
                        minimumSalary: {validation: {required: true}},
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
                {field: "minimumSalary", title: "Salary", width: "100px"},
                {field: "score", title: "Score", width: "150px"},
                {
                    template: "#if (notMarked > 0) {# <a class=\'k-button\' href=\'${createLink(controller:'mark', action: 'it')}/#:id#\'><span class='k-icon k-i-check-outline'></span></a> #}# <a class='k-button k-primary' href='javascript:viewDetails(#:id#)'><span class='k-icon k-i-zoom-in'></span></a> <a class='k-button k-danger' href='javascript:deleteApplicant(#:id#)'><span class='k-icon k-i-trash'></span></a>",
                    field: "id",
                    title: "Actions",
                    width: "260px"
                }
            ],
            editable: "popup"
        });

        grid.find(".k-grid-toolbar").on("click", ".k-return", function (e) {
            e.preventDefault();
            window.location.href = "${createLink(controller:'examTemplate', action: 'list')}";
        });
    });

    function deleteApplicant(id) {
        $.ajax({
            url: '${createLink(action:'delete')}/' + id
        }).done(function (response) {
            dataSource.read();
        });
    }

    function viewDetails(id) {
        window.location.href = "${createLink(controller: 'examSheet', action: 'details')}/" + id;
    }

    function markQuestions(id) {
        window.location.href = "${createLink(controller: 'mark', action: 'it')}/" + id;
    }
</script>

</body>
</html>
