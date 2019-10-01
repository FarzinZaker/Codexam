<%--
  Created by IntelliJ IDEA.
  User: root
  Date: 8/14/14
  Time: 4:48 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="test"/>
    <title>Apply for ${examTemplate?.name}</title>
</head>

<body>
<div class="container">

    <div class="row">
        <h1>Application Form</h1>

        <h2>${examTemplate?.name}</h2>
    </div>

    <div class="row">
        <form action="${createLink(action: 'saveApplication')}" method="POST" autocomplete="off"
              id="applicationForm">
            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-6 col-xl-6">
                <input type="hidden" name="exam.code" value="${params.id}"/>

                <p>
                    <label for="firstName">First Name</label>
                    <input type="text" class="k-textbox" name="firstName" id="firstName" style="width:100%" required
                           data-required-msg="First Name is required."/>
                </p>

                <p>
                    <label for="lastName">Last Name</label>
                    <input type="text" class="k-textbox" name="lastName" id="lastName" style="width:100%" required
                           data-required-msg="Last Name is required."/>
                </p>

                <p>
                    <label for="email">Email Address</label>
                    <input type="email" class="k-textbox" name="email" id="email" style="width:100%" required
                           data-required-msg="Email Address is required." data-email-msg="Email Address is invalid"/>
                </p>

                <p>
                    <label for="skype">Skype ID</label>
                    <input type="text" class="k-textbox" name="skype" id="skype" style="width:100%"/>
                </p>

                <p>
                    <label for="country">Country of Residence</label>
                    <g:render template="/controls/countrySelector"
                              model="${[name: 'country.id', id: 'country', style: 'width:100%']}"/>
                </p>

                <p>
                    <label for="timeZone">Time Zone</label>
                    <g:render template="/controls/timeZoneSelector"
                              model="${[name: 'timeZone.id', id: 'timeZone', style: 'width:100%']}"/>
                </p>

                <p>
                    <label for="minimumSalary">Minimum Salary / Hour</label>
                    <input type="text" name="minimumSalary" id="minimumSalary" style="width:100%" required
                           data-required-msg="Minimum Salary is required."/>
                    <script>
                        $("#minimumSalary").kendoNumericTextBox({
                            format: "$# / Hour",
                            min: 1
                        });
                    </script>
                </p>

                <p>
                    <label for="cv">CV</label>

                    <span style="width: 400px;display: block;margin-top:5px;">
                        <input name="cv" id="cv" type="file" aria-label="cv" style="width:100%"/>
                        <script>
                            $(document).ready(function () {
                                $("#cv").kendoUpload({
                                    multiple: false,
                                    allowedExtensions: [".pdf", ".doc", ".docx"],
                                    maxFileSize: 4194304,
                                    localization: {
                                        select: 'Select File'
                                    }
                                });
                            });
                        </script>
                    </span>
                </p>
            </div>

            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-6 col-xl-6">
                <h3>Agreements</h3>

                <p>By submitting this application you agree that:
                <ul>
                    <li>
                        Aclate will use your submitted information and test results to evaluate your qualifications for the <b>${examTemplate?.name}</b> role.
                    </li>
                    <li>
                        Aclate will contact you via phone, email or skype to invite you for an interview if you pass the initial test.
                    </li>
                    <li>
                        Submitting an application for the <b>${examTemplate?.name}</b> role does not quarantee that you will be hired or invited for interview.
                    </li>
                </ul>
            </p>
                <div class="note">
                    <p>
                        All the information you submit during the application process will remain confidential and the Aclate Company will never publish your personal information or test results or share it with any other entity.
                    </p>
                </div>

                <g:if test="${flash.message}">
                    <p>

                    </p>

                    <div class="error">
                        ${flash.message}
                    </div>
                </g:if>
                <p>
                    <recaptcha:recaptcha/>
                </p>

                <div class="tool-bar">
                    <input type="submit" id="submit" class="k-button k-primary" value="Start My Test"
                           onsubmit="return validateForm();"/>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    $(document).ready(function () {
        var validator = $("#applicationForm").kendoValidator().data("kendoValidator");

        function validateForm() {
            if (!validator.validate())
                return false;
        }
    });
</script>
</body>
</html>