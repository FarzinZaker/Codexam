package codxam


import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

@Secured([Roles.ADMIN, Roles.EXAMINER])
class ExamSheetController {

    def list() {
        [examTemplate: ExamTemplate.get(params.id)]
    }

    def listJSON() {
        def examTemplate = ExamTemplate.get(params.id)
        def data = ExamSheet.findAllByExamTemplateAndDeleted(examTemplate, false)?.sort { -(it.markedMark ?: 0) }
        def rank = 1
        data = data.collect {
            [
                    id       : it.id,
                    rank     : rank++,
                    name     : "${it.applicant?.firstName} ${it.applicant?.lastName}",
                    country  : "${it.applicant?.country?.name} (${it.applicant?.timeZone?.difference})",
                    score    : "%${Math.round((it.markedMark ?: 0) * 100 / (it.markedScore ?: 1))} (${it.markedMark ?: 0} / ${it.markedScore ?: 0})",
                    notMarked: it.unMarkedList?.size(),
                    endDate  : it.endDate
            ]
        }
        def total = ExamSheet.countByExamTemplateAndDeleted(examTemplate, false)
        render([data: data, total: total] as JSON)
    }

    def delete() {
        def item = ExamSheet.get(params.id)
        item.deleted = true
        item.save(flush: true)
        render([] as JSON)
    }

    def details() {
        def examSheet = ExamSheet.get(params.id)
        def topicScores = [:]
        def answers = Answer.findAllByExamSheetAndDeleted(examSheet, false)?.sort { it.sequence }
        answers.each { answer ->
            def topics = QuestionTopic.findAllByQuestion(answer.question).collect { it.topic }
            topics.each { topic ->
                if (!topicScores.containsKey(topic.name))
                    topicScores.put(topic.name, [correctAnswers: 0, wrongAnswers: 0, skipped: 0, notMarked: 0, mark: 0, score: 0])
                if (answer.answered) {
                    if (answer.mark == null)
                        topicScores[topic.name].notMarked++
                    else if (answer.mark == 0)
                        topicScores[topic.name].wrongAnswers++
                    else
                        topicScores[topic.name].correctAnswers++
                    topicScores[topic.name].mark += answer.mark ?: 0
                } else
                    topicScores[topic.name].skipped++
                topicScores[topic.name].score += answer.question?.score ?: 0
            }
        }
        [
                examSheet: examSheet, topicScores: topicScores
        ]
    }

    def resume() {
        def applicant = Applicant.get(params.id)
        if (!applicant || !applicant.cv) {
            response.status = 404
            return
        }
        response.setContentType(applicant.cvFormat) // or or image/JPEG or text/xml or whatever type the file is
        response.setHeader("Content-disposition", "attachment;filename=\"${applicant?.cvName ?: "${applicant.firstName}_${applicant.lastName}.pdf"}\"")
        response.outputStream << applicant.cv
    }
}
