<%@ page import="codxam.Country" %>
<select name="${name}" id="${id}" style="${style}" required data-required-msg="Country of Residence is required.">
    <option></option>
    <g:each in="${Country.findAllByDeleted(false).sort { it.name }}" var="country">
        <option ${country?.id == value ? 'selected' : ''} value="${country.id}">${country.name}</option>
    </g:each>
</select>

<script>
    (function () {
        $('#${id}').kendoComboBox({
            placeholder: "Select Country",
            filter: "contains",
            autoBind: true,
            change : function (e) {
                var widget = e.sender;

                if (widget.value() && widget.select() === -1) {
                    //custom has been selected
                    widget.value(""); //reset widget
                }
        }
        });
        <g:if test="${readonly}">
        $('#${id}').data('kendoComboBox').readonly(true);
        </g:if>
    })();
</script>