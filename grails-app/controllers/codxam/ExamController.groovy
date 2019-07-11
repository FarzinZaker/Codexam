package codxam

import grails.converters.JSON

class ExamController {

    def take() {
        render(ExamSheet.findById(params.id) as JSON)
    }

    def question() {
        def question = Question.get(params.id)
        [question: question, totalQuestions: 12, currentQuestion: 5]
    }
}
