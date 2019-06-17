package codxam

import codxam.examTemplates.RandomExamTemplate
import grails.converters.JSON
import grails.core.GrailsApplication
import grails.plugin.springsecurity.annotation.Secured

@Secured([Roles.ADMIN, Roles.EXAMINER])
class ExamTemplateController {

    GrailsApplication grailsApplication

    def list() {
    }

    def listJSON() {

        def value = [:]
        def parameters = [offset: params.skip, max: params.pageSize, sort: params["sort[0][field]"] ?: "name", order: params["sort[0][dir]"] ?: "asc"]

        def list
        list = ExamTemplate.findAllByDeleted(false, parameters)
        value.total = ExamTemplate.countByDeleted(false)

        value.data = list.collect {
            [
                    id         : it.id,
                    name       : it.name,
                    link       : createLink(controller: 'test', action: 'intro', id: it.uniqueId, absolute: true),
                    type       : it.class.name,
                    dateCreated: it.dateCreated,
                    lastUpdated: it.lastUpdated
            ]
        }

        render value as JSON
    }

    def form() {
        [
                examTemplate: params.id ? ExamTemplate.get(params.id) : new RandomExamTemplate(),
                types       : grailsApplication.getArtefacts("Domain").clazz.name*.toString().findAll { it.startsWith('codxam.examTemplates.') && it.endsWith('ExamTemplate') }
        ]
    }

    def save() {
        try {
            Class clazz = grailsApplication.getDomainClass(params.type).clazz
            def examTemplate = params.id ? clazz.get(params.id) : clazz.create()
            examTemplate.properties = params
            if (!examTemplate.save(flush: true)) {
                render view: '/general/errors', model: [errors: examTemplate.errors.allErrors]
                return
            }

            render '1'
        } catch (Exception ex) {
            ex.printStackTrace()
            render ex.message
        }
    }

    def listAnswerTypes() {
        def data = grailsApplication.getArtefacts("Domain").clazz.name*.toString().findAll { it.startsWith('codxam.examTemplates.') && it.endsWith('ExamTemplate') }.collect {
            [name: message(code: it), id: it]
        }
        render(data as JSON)
    }

    def delete() {
        def models = JSON.parse(params.models).collect { it.toSpreadMap() }
        models.each { model ->
            def item = ExamTemplate.get(model.id)
            item.deleted = true
            item.save(flush: true)
        }
        render([] as JSON)
    }
}
