package codxam

import com.fasterxml.jackson.databind.ObjectMapper
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

@Secured([Roles.ADMIN, Roles.EXAMINER])
class TopicController {

    def list() {
    }

    def listJSON() {
        println params
        def data = Topic.findAllByDeleted(false, [offset: params.skip, max: params.take])
        def total = Topic.countByDeleted(false)
        render([data: data, total: total] as JSON)
    }

    def form() {
        [
                topic: params.id ? Topic.get(params.id) : new Topic()
        ]
    }

    def save() {
        try {
            def topic = params.id ? Topic.get(params.id) : new Topic()
            topic.properties = params
            if (!topic.save(flush: true)) {
                render view: '/general/errors', model: [errors: topic.errors.allErrors]
                return
            }

            render topic.id
        } catch (Exception ex) {
            ex.printStackTrace()
            render ex.message
        }
    }

    def delete() {
        def models = JSON.parse(params.models).collect { it.toSpreadMap() }
        models.each { model ->
            def item = Topic.get(model.id)
            item.deleted = true
            item.save(flush: true)
        }
        render([] as JSON)
    }

    def listSimple() {
        def data = Topic.findAllByDeleted(false).collect { [name: it.name, id: it.id] }
        render(data as JSON)
    }
}
