<div>

    <p>
        <label for="firstName">First Name</label>
        <input type="text" class="k-textbox" name="firstName" id="firstName" style="width:100%"
               value="${applicant?.firstName}" readonly/>
    </p>

    <p>
        <label for="lastName">Last Name</label>
        <input type="text" class="k-textbox" name="lastName" id="lastName" style="width:100%"
               value="${applicant?.lastName}" readonly/>
    </p>

    <p>
        <label for="email">Email Address</label>
        <input type="email" class="k-textbox" name="email" id="email" style="width:100%" value="${applicant?.email}"
               readonly/>
    </p>

    <p>
        <label for="skype">Skype ID</label>
        <input type="text" class="k-textbox" name="skype" id="skype" style="width:100%" value="${applicant?.skype}"
               readonly/>
    </p>

    <p>
        <label for="country">Country of Residence</label>
        <g:render template="/controls/countrySelector"
                  model="${[name: 'country.id', id: 'country', style: 'width:100%', value: applicant?.country?.id, readonly: true]}"/>
    </p>

    <p>
        <label for="timeZone">Time Zone</label>
        <g:render template="/controls/timeZoneSelector"
                  model="${[name: 'timeZone.id', id: 'timeZone', style: 'width:100%', value: applicant?.timeZone?.id, readonly: true]}"/>
    </p>

    <p>
        <label for="minimumSalary">Minimum Salary / Hour</label>
        <input type="text" name="minimumSalary" id="minimumSalary" style="width:100%" value="${applicant?.minimumSalary}"/>
        <script>
            $("#minimumSalary").kendoNumericTextBox({
                format: "$# / Hour",
                min: 1
            });
            $("#minimumSalary").data('kendoNumericTextBox').readonly();
        </script>
    </p>

    <g:if test="${applicant?.cv}">
        <div class="tool-bar">
            <a href="${createLink(controller: 'examSheet', action: 'resume', id: applicant?.id)}"
               target="_blank" class="k-button k-primary">Download Resume</a>
        </div>
    </g:if>
</div>