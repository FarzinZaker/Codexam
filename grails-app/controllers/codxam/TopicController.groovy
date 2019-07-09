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
        def data = Topic.findAllByDeleted(false).sort { it.name }.collect {
            [
                    id      : it.id,
                    parentId: it.parent?.id,
                    name    : it.name
            ]
        }
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

            render 1
        } catch (Exception ex) {
            ex.printStackTrace()
            render ex.message
        }
    }

    def delete() {
        def item = Topic.get(params.id)
        item.deleted = true
        item.save(flush: true)
        render([] as JSON)
    }

    def listSimple() {
        def data = Topic.findAllByDeleted(false).collect { [name: it.fullName, id: it.id] }
        render(data as JSON)
    }
}
