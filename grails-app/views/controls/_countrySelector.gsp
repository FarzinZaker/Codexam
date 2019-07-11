<%@ page import="codxam.Country" %>
<select name="${name}" id="${id}" style="${style}" required data-required-msg="Country of Residence is required.">
    <option></option>
    <g:each in="${Country.findAllByDeleted(false).sort { it.name }}" var="country">
        <option value="${country.id}">${country.name}</option>
    </g:each>
</select>

<script>
    (function () {
        $('#${id}').kendoComboBox({
            placeholder: "Select Country",
            filter: "contains",
            autoBind: true
        });
    })();
</script>