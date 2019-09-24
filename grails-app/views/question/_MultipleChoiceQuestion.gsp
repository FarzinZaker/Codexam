<%@ page import="codxam.questions.MultipleChoiceQuestion; codxam.questions.QuestionChoice" %>
<g:if test="${question instanceof MultipleChoiceQuestion}">
    <label for="options">Options</label>

    <div id="options"></div>


    <span onclick="addOption()" class="k-add k-link k-button" title="New" style="margin-top:5px;"><span class="k-icon k-i-plus"></span>Add New Option</span>



    <script>
        (function () {
            $("#options").kendoSortable().find('input').click(function () {
                $(this).focus();
            });

            <g:each in="${question?.id ? QuestionChoice.findAllByQuestionAndDeleted(question, false)?.sort { it.displayOrder } : []}" var="choice">
            addOptionWithData(${choice.id}, '${choice.name}', ${choice.correctAnswer});
            </g:each>

        })();

        function removeOption(element) {
            console.log($(element));
            $(element).parent().remove()
        }

        function addOption() {
            addOptionWithData(0, '', false)
        }

        function addOptionWithData(id, name, correct) {
            var guid = kendo.guid();
            var options = $('#options');
            options.append(
                $('<div>\n' +
                    '        <input id="' + guid + '" type="radio" value="' + guid + '" name="correctAnswerUniqueId" ' + (correct ? 'checked="checked"' : '') + '/>' +
                    '        <label class="k-radio-label no-margin" for="' + guid + '">&#8203;</label>' +
                    '        <input type="hidden" name="options.uniqueId" value="' + guid + '"/>' +
                    '        <input type="hidden" name="options.id" value="' + id + '"/>' +
                    '        <input type="text" class="k-textbox" name="options.name" style="width: 500px" value="' + name + '"/>\n' +
                    '        <span onclick="removeOption(this)" class="k-add k-link k-button k-button-icon" title="New"><span class="k-icon k-i-close"></span></span>\n' +
                    '    </div>')).kendoSortable();
            options.find('input').click(function () {
                $(this).focus();
            });
            options.find('input[type="radio"]').addClass('k-radio');
        }
    </script>
</g:if>