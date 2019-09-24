package codxam

class ExamController {

    def take() {
        def examSheet = ExamSheet.get(params.id)
        if (!examSheet.startDate) {
            examSheet.startDate = new Date()
            examSheet.currentQuestionIndex = 1
            examSheet.save(flush: true)
        }

        if (params.question) {
            examSheet.currentQuestionIndex = params.question?.toString()?.toInteger()
            examSheet.save(flush: true)
            redirect(action: 'take', id: examSheet.id)
        }

        def totalQuestions = Answer.countByExamSheetAndDeleted(examSheet, false)

        if(examSheet.currentQuestionIndex < 1){
            examSheet.currentQuestionIndex = 1
            examSheet.save(flush:true)
        }

        if(examSheet.currentQuestionIndex > totalQuestions){
            examSheet.currentQuestionIndex = totalQuestions
            examSheet.save(flush:true)
        }

        def answer = Answer.findByExamSheetAndSequenceAndDeleted(examSheet, examSheet.currentQuestionIndex, false)
        def question = answer.question

        [examSheet: examSheet, answer: answer, question: question, totalQuestions: totalQuestions, currentQuestion: examSheet.currentQuestionIndex]
    }

    def next() {
        def examSheet = ExamSheet.get(params.id?.toString()?.toLong())
        if (params.next) {
            examSheet.currentQuestionIndex++
            examSheet.save(flush: true)
        }
        redirect(action: 'take', id: examSheet.id)
    }

    def previous() {
        def examSheet = ExamSheet.get(params.id?.toString()?.toLong())
        if (params.next) {
            examSheet.currentQuestionIndex++
            examSheet.save(flush: true)
        }
        redirect(action: 'take', id: examSheet.id)
    }

    def saveAnswer() {

        def examSheet = ExamSheet.get(params.examSheet?.toString()?.toLong())
        def question = ExamSheet.get(params.question)

        //save answer
        println params

        examSheet.currentQuestionIndex++
        examSheet.save(flush: true)
        redirect(action: 'take', id: examSheet.id)
    }
}


