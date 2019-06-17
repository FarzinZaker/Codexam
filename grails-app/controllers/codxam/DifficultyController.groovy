package codxam

import codxam.examTemplates.QuestionFilter
import codxam.examTemplates.RandomExamTemplate
import com.fasterxml.jackson.databind.ObjectMapper
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

@Secured([Roles.ADMIN])
class DifficultyController {

    def list() {
    }

    def listJSON() {
        def data = Difficulty.findAllByDeleted(false, [offset: params.skip, max: params.take])
        def total = Difficulty.countByDeleted(false)
        render([data: data, total: total] as JSON)
    }

    def form() {
        [
                difficulty: params.id ? Difficulty.get(params.id) : new Difficulty()
        ]
    }

    def save() {
        try {
            def difficulty = params.id ? Difficulty.get(params.id) : new Difficulty()
            difficulty.properties = params
            if (!difficulty.save(flush: true)) {
                render view: '/general/errors', model: [errors: difficulty.errors.allErrors]
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
            def item = Difficulty.get(model.id)
            item.deleted = true
            item.save(flush: true)
        }
        render([] as JSON)
    }

    def listSimple() {
        def data = Difficulty.findAllByDeleted(false).collect { [name: it.name, id: it.id] }
        render(data as JSON)
    }
}
