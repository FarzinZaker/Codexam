<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Test Topics</title>
</head>

<body>
<h1>Test Topics</h1>

<div id="tree"></div>

<div id="form"></div>

<ul id="context-menu">
    <li id="cm_edit">Edit</li>
    <li id="cm_add">Add Child</li>
    <li id="cm_delete">Delete</li>
</ul>

<script id="treeview-template" type="text/kendo-ui-template">
#: item.name #
# if (item.questionsCount > 0) { #
<span class="questions-flag" title="Questions"><a target="_blank"
                                                  href="${createLink(controller: 'question', action: 'list')}/#: item.id #">#: item.questionsCount#</a>
</span>
# } #
# if (item.singleParentQuestions > 0) { #
<span class="single-topic-questions-flag" title="Single Topic Questions"><b>#: item.singleParentQuestions#</b></span>
# } #
</script>

<script>
    var tree, wnd, dataSource;
    $(document).ready(function () {
        dataSource = new kendo.data.HierarchicalDataSource({
            transport: {
                read: {
                    url: "${createLink(action: 'treeJSON')}",
                    dataType: "json"
                }
            },
            schema: {
                model: {
                    id: "id",
                    parentId: "parentId",
                    hasChildren: "hasChildren",
                    fields: {
                        parentId: {field: "parentId", nullable: true},
                        name: {field: "name", type: "string"},
                        id: {field: "id", type: "number"}
                    },
                    // expanded: true
                }
            }
        });

        tree = $("#tree").kendoTreeView({
            dataSource: dataSource,
            template: kendo.template($("#treeview-template").html()),
            dataTextField: "name",
            dragAndDrop: true,
            dragend: onDragEnd
        });

        wnd = $("#form")
            .kendoWindow({
                title: "Test Topic Form",
                modal: true,
                visible: false,
                resizable: false,
                width: 600
            }).data("kendoWindow");

        $("#context-menu").kendoContextMenu({
            // listen to right-clicks on treeview container
            target: "#tree",

            // show when node text is clicked
            filter: ".k-in",

            // handle item clicks
            select: function (e) {
                var action = $(e.item).attr('id');
                var id = $('#tree').data('kendoTreeView').dataItem(e.target).id;
                if (action === 'cm_edit')
                    editTopic(id);
                else if (action === 'cm_add')
                    addChildTopic(id);
                else if (action === 'cm_delete')
                    deleteTopic(id);
            }
        });
    });

    function onDragEnd(e) {
        $.ajax({
            url: "${createLink(action: 'move')}",
            data: {
                node: $('#tree').data('kendoTreeView').dataItem(e.sourceNode).id,
                parent: $('#tree').data('kendoTreeView').dataItem(e.destinationNode).id
            }
        }).done(function () {
        });
    }

    function editTopic(id) {
        kendo.ui.progress(wnd.element, true);

        wnd.refresh({
            url: '${createLink(action:'form')}',
            data: {id: id}
        });
        wnd.bind("refresh", function () {
            wnd.center();
            wnd.open();
        });
        wnd.title('Edit Test Topic').center().open();
    }

    function deleteTopic(id) {
        kendo.ui.progress(wnd.element, true);

        wnd.refresh({
            url: '${createLink(action:'deleteForm')}',
            data: {id: id}
        });
        wnd.bind("refresh", function () {
            wnd.center();
            wnd.open();
        });
        wnd.title('Delete Test Topic').center().open();
    }

    function addChildTopic(id) {
        kendo.ui.progress(wnd.element, true);

        wnd.refresh({
            url: '${createLink(action:'form')}',
            data: {parentId: id}
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