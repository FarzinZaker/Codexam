<h2>
    Upload the answer file
</h2>
<g:if test="${answer.answered}">
    Uploaded file:
    <div class="uploaded-file">
        <span class="k-icon k-i-file k-i-${answer.fileFormat}"></span> <span>${answer.fileName}</span>
    </div>
    <div class="overwrite-file">Submit a new answer:</div>
</g:if>
<span class="k-widget k-tooltip k-tooltip-validation k-invalid-msg" style="display: none" data-for="answer" role="alert"
      id="validatorMessage"><span class="k-icon k-i-warning"></span> Please upload the answer file first.</span>
<span class="k-widget k-tooltip k-tooltip-validation k-invalid-msg" style="display: none" data-for="answer" role="alert"
      id="sizeValidatorMessage"><span class="k-icon k-i-warning"></span> Selected file is too big!</span>
<input name="answer" id="answerUploader" type="file" aria-label="answer" style="width:100%"/>
<script>
    $(document).ready(function () {
        $("#answerUploader").kendoUpload({
            multiple: false,
            // allowedExtensions: [".pdf", ".doc", ".docx"],
            maxFileSize: 4194304,
            localization: {
                select: 'Select File'
            },
            select: function (e) {
                if (e.files[0].size > 4194304) {
                    $('#sizeValidatorMessage').slideDown();
                    e.preventDefault();
                } else {
                    $('#sizeValidatorMessage').slideUp();
                }
            }
        });
    });

    function internalValidate() {
        return $('#answerUploader').closest(".k-upload").find(".k-file").length;
    }
</script>