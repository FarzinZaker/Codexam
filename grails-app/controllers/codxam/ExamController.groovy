package codxam


import codxam.questions.MultipleChoiceQuestion
import codxam.questions.QuestionChoice
import groovy.time.TimeCategory
import groovy.time.TimeDuration

class ExamController {

    def take() {
        def examSheet = ExamSheet.get(params.id)

        if (params.question) {
            examSheet.currentQuestionIndex = params.question?.toString()?.toInteger()
            examSheet.save(flush: true)
            redirect(action: 'take', id: examSheet.id)
        }

        def totalQuestions = Answer.countByExamSheetAndDeleted(examSheet, false)

        if (examSheet.currentQuestionIndex < 1) {
            examSheet.currentQuestionIndex = 1
            examSheet.save(flush: true)
        }

        if (examSheet.currentQuestionIndex > totalQuestions) {
            examSheet.currentQuestionIndex = totalQuestions
            examSheet.save(flush: true)
        }

        def answers = Answer.findAllByExamSheetAndDeleted(examSheet, false)?.sort { it.sequence }
        def answer = answers.find { it.sequence == examSheet.currentQuestionIndex }
        def question = answer.question

        if (!examSheet.totalTime) {
            examSheet.totalTime = answers.sum { it.question.timeLimit }
            examSheet.save(flush: true)
        }

        if (!examSheet.startDate) {
            examSheet.startDate = new Date()
            examSheet.currentQuestionIndex = 1
            examSheet.save(flush: true)
        }

        TimeDuration remainingTime
        use(TimeCategory) {
            Date expectedEndDate = examSheet.startDate + (examSheet.totalTime).minutes
            if (expectedEndDate < new Date() || examSheet.endDate)
                redirect(action: 'results', id: examSheet.id)

            remainingTime = TimeCategory.minus(expectedEndDate, new Date())
        }

        [examSheet: examSheet, answer: answer, answers: answers, question: question, totalQuestions: totalQuestions, currentQuestion: examSheet.currentQuestionIndex, remainingTime: remainingTime]
    }

    def next() {
        def examSheet = ExamSheet.get(params.id?.toString()?.toLong())
        examSheet.currentQuestionIndex++
        examSheet.save(flush: true)
        redirect(action: 'take', id: examSheet.id)
    }

    def previous() {
        def examSheet = ExamSheet.get(params.id?.toString()?.toLong())
        examSheet.currentQuestionIndex--
        examSheet.save(flush: true)

        redirect(action: 'take', id: examSheet.id)
    }

    def saveAnswer() {

        def examSheet = ExamSheet.get(params.examSheet?.toString()?.toLong())
        def answer = Answer.get(params.question)
        def question = answer.question

        //save answer
        if (question.toString().contains('MultipleChoiceQuestion')) {
            answer.choice = QuestionChoice.get(params.answer)
            if (answer.choice.id == QuestionChoice.findByQuestionAndCorrectAnswer(question as MultipleChoiceQuestion, true).id)
                answer.mark = question.score ?: 1
            else
                answer.mark = 0
        } else if (question.toString().contains('ShortAnswerQuestion'))
            answer.body = params.answer
        else if (question.toString().contains('FileQuestion')) {
            answer.file = params.answer.bytes
            answer.fileFormat = params.answer.contentType
            answer.fileName = params.answer.filename
        }
        answer.save()

        examSheet.currentQuestionIndex++
        examSheet.save(flush: true)
        redirect(action: 'take', id: examSheet.id)
    }

    def finish() {
        def examSheet = ExamSheet.get(params.id?.toString()?.toLong())
        examSheet.endDate = new Date()
        examSheet.save(flush: true)

        redirect(action: 'take', id: examSheet.id)
    }

    def results() {
        [
                examSheet: ExamSheet.get(params.id)
        ]
    }
}


