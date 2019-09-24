package codxam

import com.fasterxml.jackson.databind.ObjectMapper
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

@Secured([Roles.ADMIN, Roles.EXAMINER])
class TopicController {

    def list() {
    }

    def tree() {
    }

    def listJSON() {
        println params
        def data = Topic.findAllByDeleted(false).sort { it.name }.collect {
            [
                    id      : it.id,
                    parentId: it.parent?.id,
                    name    : it.name,
                    expanded: it.parent == null
            ]
        }
        def total = Topic.countByDeleted(false)
        render([data: data, total: total] as JSON)
    }

    def treeJSON() {
        println params

        render((!params.id ? Topic.findAllByDeletedAndParentIsNull(false) : Topic.findAllByParentAndDeleted(Topic.get(params.id), false)).sort {
            it.name
        }.collect {
            def questions = QuestionTopic.findAllByTopic(it).findAll { !it.question.deleted && !it.topic.deleted }
            [
                    id                   : it.id,
                    name                 : it.name,
                    hasChildren          : it.children?.size() > 0,
                    expanded             : !params.id,
                    questionsCount       : questions.size(),
                    singleParentQuestions: questions.count { QuestionTopic.countByQuestion(it.question) < 2 }
            ]
        } as JSON)
    }

    def form() {
        def topic = params.id ? Topic.get(params.id) : (params.parentId ? new Topic(parent: Topic.get(params.parentId)) : new Topic())
        def suggestedTopics = [:]

        if (params.id) {
            def questions = QuestionTopic.findAllByTopic(topic).collect { it.question }
            questions.each { question ->
                def topics = QuestionTopic.findAllByQuestion(question).collect { it.topic }.findAll({
                    it.id != topic.id && !it.deleted
                })
                topics.each {
                    if (!suggestedTopics.containsKey(it))
                        suggestedTopics.put(it, 0)
                    suggestedTopics[it]++
                }
            }
        }

        [
                topic: topic, suggestedTopics: suggestedTopics
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

    def deleteForm() {

        def topic = Topic.get(params.id)
        def questions = QuestionTopic.findAllByTopic(topic).collect { it.question }
        def suggestedTopics = [:]
        questions.each { question ->
            def topics = QuestionTopic.findAllByQuestion(question).collect { it.topic }.findAll({
                it.id != topic.id && !it.deleted
            })
            topics.each {
                if (!suggestedTopics.containsKey(it))
                    suggestedTopics.put(it, 0)
                suggestedTopics[it]++
            }
        }

        [
                topic: topic, suggestedTopics: suggestedTopics
        ]
    }

    def delete() {
        def item = Topic.get(params.id)
        def newTopic = Topic.get(params.parent.id)
        QuestionTopic.findAllByTopic(item).each { questionTopic ->
            if (QuestionTopic.findByTopicAndQuestion(newTopic, questionTopic.question))
                questionTopic.delete()
            else {
                questionTopic.topic = newTopic
                questionTopic.save()
            }
        }
        item.deleted = true
        item.save(flush: true)
        render '1'
    }

    def listSimple() {
        def data = Topic.findAllByDeleted(false).collect { [name: it.fullName, id: it.id] }
        render(data as JSON)
    }

    def move() {
        def node = Topic.get(params.node)
        def parent = Topic.get(params.parent)
        node.parent = parent
        node.save(flush: true)
        render '0'
    }
}
