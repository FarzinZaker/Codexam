package codxam

import codxam.examTemplates.QuestionFilter
import codxam.examTemplates.RandomExamTemplate
import codxam.questions.MultipleChoiceQuestion
import codxam.questions.QuestionChoice
import grails.converters.JSON
import grails.core.GrailsApplication
import grails.plugin.springsecurity.annotation.Secured

@Secured([Roles.ADMIN, Roles.EXAMINER])
class QuestionFilterController {

    GrailsApplication grailsApplication

    def list() {
        [examTemplate: ExamTemplate.get(params.id)]
    }

    def listJSON() {

        def value = [:]
        def parameters = [offset: params.skip, max: params.pageSize, sort: params["sort[0][field]"] ?: "count", order: params["sort[0][dir]"] ?: "asc"]

        def list
        def examTemplate = RandomExamTemplate.get(params.id)
        list = QuestionFilter.findAllByExamTemplateAndDeleted(examTemplate, false, parameters)
        value.total = QuestionFilter.countByExamTemplateAndDeleted(examTemplate, false)

        value.data = list.collect {
            [
                    id         : it.id,
                    topic      : it.topic?.name,
                    difficulty : it.difficulty?.name,
                    count      : it.count,
                    dateCreated: it.dateCreated,
                    lastUpdated: it.lastUpdated
            ]
        }

        render value as JSON
    }

    def form() {
        [
                questionFilter: params.id ? QuestionFilter.get(params.id) : new QuestionFilter(examTemplate: RandomExamTemplate.get(params.examTemplate)),
        ]
    }

    def save() {
        try {
            def questionFilter = params.id ? QuestionFilter.get(params.id) : new QuestionFilter()
            questionFilter.properties = params
            if (!questionFilter.save(flush: true)) {
                render view: '/general/errors', model: [errors: questionFilter.errors.allErrors]
                return
            }

            render '1'
        } catch (Exception ex) {
            ex.printStackTrace()
            render ex.message
        }
    }

    def delete() {
        def models = JSON.parse(params.models).collect { it.toSpreadMap() }
        models.each { model ->
            def item = QuestionFilter.get(model.id)
            item.deleted = true
            item.save(flush: true)
        }
        render([] as JSON)
    }
}
