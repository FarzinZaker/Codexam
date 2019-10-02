<%@ page import="codxam.TimeZone;" %>
<select name="${name}" id="${id}" style="${style}" required data-required-msg="Time Zone is required.">
    <option></option>
    <g:each in="${TimeZone.findAllByDeleted(false).sort {
        it.difference.replace('GMT', '').replace(':', '').toInteger()
    }}" var="timeZone">
        <option ${timeZone?.id == value ? 'selected' : ''}
                value="${timeZone.id}">(${timeZone.difference}) ${timeZone.location}</option>
    </g:each>
</select>

<script>
    (function () {
        $('#${id}').kendoComboBox({
            placeholder: "Select TimeZone",
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