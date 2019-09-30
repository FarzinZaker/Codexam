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
    <title>Exam Templates</title>
</head>

<body>
<h1>Exam Templates</h1>

<div id="grid"></div>

<div id="form"></div>

<script type="text/x-kendo-template" id="toolbarTemplate">
<div class="refreshBtnContainer">
    <a href="\\#" class="k-add k-link k-button" title="New"><span class="k-icon k-i-plus"></span> New Exam Template</a>
</div>
</script>
<script>
    var wnd, grid, dataSource;
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
            pageSize: 20,
            schema: {
                data: 'data',
                total: 'total',
                model: {
                    id: "id",
                    fields: {
                        name: {type: "string", validation: {required: true}},
                        link: {type: "string"},
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
                {field: "name", title: "Name"},
                {field: "link", title: "Link", template: "<a href='#: link #' target='_blank'>#: link #</a>"},
                // {field: "dateCreated", title: "Created", format: "{0:MM/dd/yyyy h:mm tt}"},
                // {field: "lastUpdated", title: "Updated", format: "{0:MM/dd/yyyy h:mm tt}"},
                {command: [{text: "Applicants", click: viewApplicants},{text: "Edit", click: editExamTemplate}, {text: "Filters", click: listFilters}, "destroy"], title: " ", width: "470px"}
            ],
            editable: "popup",
            edit: function (e) {
                $(e.container).find('input[type="checkbox"]').addClass('k-checkbox');
            }
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
            wnd.title('New ExamSheet Template').center().open();
        });

        wnd = $("#form")
            .kendoWindow({
                title: "Edit ExamSheet Template",
                modal: true,
                visible: false,
                resizable: false,
                width: 600
            }).data("kendoWindow");

    });

    function editExamTemplate(e) {
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
        wnd.title('Edit ExamSheet Template').center().open();
    }

    function listFilters(e) {
        e.preventDefault();

        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        window.location.href = "${createLink(controller:'questionFilter', action:'list')}/" + dataItem.id;
    }

    function viewApplicants(e) {
        e.preventDefault();

        var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
        window.location.href = "${createLink(controller:'examSheet', action:'list')}/" + dataItem.id;
    }
</script>
</body>
</html>