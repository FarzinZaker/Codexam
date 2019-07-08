<%@ page import="codxam.Topic" %>
<input id="${id}" name="${name}" style="${style}" value="${value}"/>

<script>
    $(document).ready(function () {
        $("#${id}").kendoDropDownTree({
            placeholder: "Select ...",
            height: "auto",
            dataSource: [
                <g:each in="${Topic.findAllByParentIsNullAndDeleted(false).sort{it.name}}" var="topic">
                <g:render template="selectorOption" model="${[topic: topic, value: value]}"/>,
                </g:each>
            ]
        });
    });
</script>