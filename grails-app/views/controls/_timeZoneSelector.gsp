<%@ page import="codxam.TimeZone;" %>
<select name="${name}" id="${id}" style="${style}" required data-required-msg="Time Zone is required.">
    <option></option>
    <g:each in="${TimeZone.findAllByDeleted(false).sort {
        it.difference.replace('GMT', '').replace(':', '').toInteger()
    }}" var="timeZone">
        <option value="${timeZone.id}">(${timeZone.difference}) ${timeZone.location}</option>
    </g:each>
</select>

<script>
    (function () {
        $('#${id}').kendoComboBox({
            placeholder: "Select TimeZone",
            filter: "contains",
            autoBind: true
        });
    })();
</script>