package codxam


import codxam.questions.MultipleChoiceQuestion
import codxam.questions.QuestionChoice
import grails.converters.JSON
import grails.core.GrailsApplication
import grails.plugin.springsecurity.annotation.Secured

@Secured([Roles.ADMIN, Roles.EXAMINER])
class QuestionController {

    GrailsApplication grailsApplication

    def list() {
        [topic: Topic.get(params.id)]
    }

    def listJSON() {

        def value = [:]
        def parameters = [offset: params.skip, max: params.pageSize, sort: params["sort[0][field]"] ?: "title", order: params["sort[0][dir]"] ?: "asc"]

        def list
        def topic = Topic.get(params.id)
        def questionIds = QuestionTopic.findAllByTopicInList([topic] + topic.allChildren)?.collect { it.question?.id }
        list = questionIds ? Question.findAllByIdInListAndDeleted(questionIds, false, parameters) : []
        value.total = questionIds ? Question.countByIdInListAndDeleted(questionIds, false) : 0

        value.data = list.collect { record ->
            [
                    id         : record.id,
                    title      : record.title,
                    difficulty : record.difficulty?.name,
                    type       : message(code: record?.toString()?.split(':')?.find()?.trim()),
                    timeLimit  : record.timeLimit,
                    score      : record.score,
//                    topics     : QuestionTopic.findAllByQuestion(record)?.findAll { !it.topic.deleted }?.collect {
//                        it.topic?.name
//                    }?.join(' ,'),
                    dateCreated: record.dateCreated,
                    lastUpdated: record.lastUpdated
            ]
        }

        render value as JSON
    }

    def form() {
        [
                question: params.id ? Question.get(params.id) : new MultipleChoiceQuestion(),
                types   : grailsApplication.getArtefacts("Domain").clazz.name*.toString().findAll {
                    it.startsWith('codxam.questions.') && it.endsWith('Question')
                }
        ]
    }

    def save() {
        try {
            Class clazz = grailsApplication.getDomainClass(params.type).clazz
            def question = params.id ? clazz.get(params.id) : clazz.create()
            question.properties = params
            if (!question.save()) {
                render view: '/general/errors', model: [errors: question.errors.allErrors]
                return
            }

            //topics
            def topics = Topic.findAllByIdInList(params.topics?.split(',')?.collect { it.toLong() })

            if (topics?.size()) {
                QuestionTopic.findAllByQuestionAndTopicNotInList(question, topics).each { it.delete() }

                topics.each { Topic topic ->
                    if (!QuestionTopic.findByQuestionAndTopic(question, topic))
                        new QuestionTopic(question: question, topic: topic).save()
                }
            } else
                throw new Exception("No topic is selected")

            if (question instanceof MultipleChoiceQuestion) {
                def mcQuestion = question as MultipleChoiceQuestion
                def options = params.options

                //removed choices
                def removedChoices = mcQuestion.choices?.findAll { !options.id.contains(it.id?.toString()) }?.collect {
                    it.id
                }
                if (removedChoices)
                    QuestionChoice.findAllByQuestionAndIdInListAndDeleted(mcQuestion, removedChoices, false).each {
                        it.deleted = true
                        it.save()
                    }

                //at least two choices
                if (options?.name instanceof String || !options?.name)
                    throw new Exception('At least two options are required.')

                //save or update choices
                for (def i = 0; i < options?.name?.size(); i++) {
                    def choice
                    if (options.id[i] == '0') {
                        //save new choice
                        choice = new QuestionChoice(name: options.name[i], question: mcQuestion, displayOrder: i + 1)
                        if (!choice.save(flush: true)) {
                            render view: '/general/errors', model: [errors: choice.errors.allErrors]
                            return
                        }
                    } else {
                        //update choice
                        choice = QuestionChoice.get(options.id[i]?.toString()?.toLong())
                        choice.name = options.name[i]
                        choice.displayOrder = i + 1
                        if (!choice.save(flush: true)) {
                            render view: '/general/errors', model: [errors: choice.errors.allErrors]
                            return
                        }
                    }

                    //update correct answer
                    if (options.uniqueId[i] == params.correctAnswerUniqueId)
                        mcQuestion.correctAnswer = choice
                }

                if (!mcQuestion.correctAnswer || mcQuestion.correctAnswer?.deleted || mcQuestion.correctAnswer.question.id != mcQuestion.id)
                    throw new Exception('Correct answer is not specified.')
            }

            question.save(flush: true)
            render '1'
        } catch (Exception ex) {
            ex.printStackTrace()
            render ex.message
        }
    }

    def listAnswerTypes() {
        def data = grailsApplication.getArtefacts("Domain").clazz.name*.toString().findAll {
            it.startsWith('codxam.questions.') && it.endsWith('Question')
        }.collect {
            [name: message(code: it), id: it]
        }
        render(data as JSON)
    }

    def delete() {
        def ids = JSON.parse(params.models).collect { it.toSpreadMap() }.collect { it.id?.toLong() }
        Question.executeUpdate("update Question set deleted = true where id in :list", [list: ids])
//        models.each { model ->
//            def item = Question.get(model.id)
//            item.deleted = true
//            item.save(flush: true)
//        }
        render([] as JSON)
    }
}
