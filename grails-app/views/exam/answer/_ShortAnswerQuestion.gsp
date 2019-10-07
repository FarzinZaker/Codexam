<h2>Type your answer</h2>
<span class="k-widget k-tooltip k-tooltip-validation k-invalid-msg" style="display: none" data-for="answer" role="alert"
      id="validatorMessage"><span class="k-icon k-i-warning"></span> Please type your answer first.</span>
<span id="editorContainer">
    <textarea type="text" class="k-textbox" name="answer" id="answer" style="width: 100%;height:300px;"><format:html
            value="${answer?.body}"/></textarea>
</span>

<script language="JavaScript">
    $(document).ready(function () {
        if (tinymce.get("answer"))
            tinymce.get("answer").remove();

        tinymce.init({
            selector: 'textarea#answer',
            height: 500,
            menubar: false,
            plugins: [
                'advlist autolink lists link image charmap print preview anchor',
                'searchreplace visualblocks code fullscreen image',
                'insertdatetime media table paste code help wordcount codesample code'
            ],
            codesample_languages: [
                {text: 'HTML/XML', value: 'markup'},
                {text: 'JavaScript', value: 'javascript'},
                {text: 'CSS', value: 'css'},
                {text: 'PHP', value: 'php'},
                {text: 'Ruby', value: 'ruby'},
                {text: 'Python', value: 'python'},
                {text: 'Java', value: 'java'},
                {text: 'C', value: 'c'},
                {text: 'C#', value: 'csharp'},
                {text: 'C++', value: 'cpp'}
            ],
            toolbar: 'undo redo formatselect bold italic backcolor alignleft aligncenter alignright alignjustify bullist numlist outdent indent removeformat image codesample code',
            content_css: [
                '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
                '//www.tiny.cloud/css/codepen.min.css'
            ],
            images_upload_url: '${createLink(controller: 'image', action:'upload')}'
        });
    });

    function internalValidate() {
        var tmp = document.createElement("DIV");
        tmp.innerHTML = tinyMCE.activeEditor.getContent();
        return (tmp.textContent || tmp.innerText) ? true : false
    }
</script>