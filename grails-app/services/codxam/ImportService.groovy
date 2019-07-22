package codxam

import codxam.external.ExternalQuestion
import codxam.external.ExternalQuestionChoice
import codxam.questions.FileQuestion
import codxam.questions.MultipleChoiceQuestion
import codxam.questions.QuestionChoice
import codxam.questions.ShortAnswerQuestion
import grails.gorm.transactions.Transactional

//@Transactional
class ImportService {

    def importHackerRank() {
        def list = ExternalQuestion.findAllBySourceAndImported('HackerRank', false)
        def indexer = 1
        list.each { externalQuestion ->

            Question.withNewTransaction {

                def difficulty = Difficulty.findByName(externalQuestion.difficulty)
                if (!difficulty)
                    difficulty = new Difficulty(name: externalQuestion.difficulty).save(flush: true)

                def question
                if (['Multiple Answers', 'Multiple Choice'].contains(externalQuestion.type))
                    question = new MultipleChoiceQuestion()
                else if (['DevOps'].contains(externalQuestion.type))
                    question = new ShortAnswerQuestion()
                else
                    question = new FileQuestion()
                question.title = externalQuestion.name
                question.score = externalQuestion.score
                question.body = externalQuestion.body
                question.timeLimit = externalQuestion.timeLimit
                question.difficulty = difficulty
                question.save(flush: true)

                externalQuestion.tags.each { tag ->
                    def topic = Topic.findByName(tag.name)
                    if (!topic)
                        topic = new Topic(name: tag.name).save(flush: true)
                    new QuestionTopic(question: question, topic: topic).save(flush: true)
                }

                if (question instanceof MultipleChoiceQuestion)
                    ExternalQuestionChoice.findAllByQuestion(externalQuestion).each {
                        new QuestionChoice(name: it.title, correctAnswer: it.correctAnswer, displayOrder: it.displayOrder, question: question).save(flush: true)
                    }

            }
            println "${indexer++}/${list.size()}"
        }
    }
}
