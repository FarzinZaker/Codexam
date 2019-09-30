package codxam


import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

@Secured([Roles.ADMIN])
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
}
