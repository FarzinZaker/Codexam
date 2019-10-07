package codxam

import codxam.answers.FileAnswer
import codxam.questions.MultipleChoiceQuestion
import codxam.questions.QuestionChoice
import grails.plugin.springsecurity.annotation.Secured
import groovy.time.TimeCategory
import groovy.time.TimeDuration

@Secured([Roles.ADMIN, Roles.EXAMINER])
class MarkController {

    def it() {
        def examSheet = ExamSheet.get(params.id)

        if (params.question) {
            examSheet.currentMarkingIndex = params.question?.toString()?.toInteger()
            examSheet.save(flush: true)
            redirect(action: 'it', id: examSheet.id)
            return
        }

        def totalQuestions = examSheet.unMarkedList.size()

        if (!examSheet.currentMarkingIndex || examSheet.currentMarkingIndex < 1) {
            examSheet.currentMarkingIndex = 1
            examSheet.save(flush: true)
        }

        if (examSheet.currentMarkingIndex > totalQuestions) {
            examSheet.currentMarkingIndex = totalQuestions
            examSheet.save(flush: true)
        }

        def answers = Answer.findAllByExamSheetAndMarkIsNullAndDeleted(examSheet, false)?.findAll {
            it.answered
        }?.sort { it.sequence }
        if (!answers.size())
            redirect(controller: 'examSheet', action: 'list', id: examSheet?.examTemplate.id)
        else {
            def answer = answers.size() > examSheet.currentMarkingIndex - 1 ? answers[examSheet.currentMarkingIndex - 1] : null
            def question = answer?.question

            [examSheet: examSheet, answer: answer, answers: answers, question: question, totalQuestions: totalQuestions, currentQuestion: examSheet.currentMarkingIndex]
        }
    }

    def next() {
        def examSheet = ExamSheet.get(params.id?.toString()?.toLong())
        examSheet.currentMarkingIndex++
        examSheet.save(flush: true)
        redirect(action: 'it', id: examSheet.id)
    }

    def previous() {
        def examSheet = ExamSheet.get(params.id?.toString()?.toLong())
        examSheet.currentMarkingIndex--
        examSheet.save(flush: true)

        redirect(action: 'it', id: examSheet.id)
    }

    def saveMark() {

        def examSheet = ExamSheet.get(params.examSheet?.toString()?.toLong())
        def answer = Answer.get(params.question)
        def question = answer.question

        answer.mark = params.mark?.toInteger()
        answer.save()

        examSheet.currentMarkingIndex++
        examSheet.save(flush: true)
        redirect(action: 'it', id: examSheet.id)
    }

    def download() {
        def answer = FileAnswer.get(params.id)
        if (!answer || !answer.file) {
            response.status = 404
            return
        }
        response.setContentType(answer.fileFormat) // or or image/JPEG or text/xml or whatever type the file is
        response.setHeader("Content-disposition", "attachment;filename=\"${answer.fileName}\"")
        response.outputStream << answer.file
    }
}


