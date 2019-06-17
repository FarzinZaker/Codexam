package codxam

class TestController {

    def intro() {
        [examTemplate: ExamTemplate.findByUniqueId(params.id)]
    }

    def apply() {
        [examTemplate: ExamTemplate.findByUniqueId(params.id)]
    }

    def question() {
        def question = Question.get(params.id)
        [question: question, totalQuestions: 12, currentQuestion: 5]
    }
}
