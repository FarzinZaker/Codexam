package codxam

import codxam.answers.FileAnswer
import codxam.answers.TextAnswer
import codxam.answers.MultipleChoiceAnswer
import codxam.examTemplates.QuestionFilter
import codxam.examTemplates.RandomExamTemplate
import codxam.questions.FileQuestion
import codxam.questions.MultipleChoiceQuestion
import codxam.questions.ShortAnswerQuestion
import grails.gorm.transactions.Transactional

@Transactional
class QuestionFilterService {

    def grailsApplication

    def validate(RandomExamTemplate template) {
        def filters = QuestionFilter.findAllByExamTemplateAndDeleted(template, false)
        def questions = []
        filters.each { filter ->

            def list = QuestionTopic.createCriteria().list {
                'in'('topic', [filter.topic] + filter.topic.allChildren)
                question {
                    eq('difficulty', filter.difficulty)
                }
                projections {
                    property('question')
                }
            }
            list = list.findAll {
                !questions.contains(it) &&
                        it.toString().contains(filter.questionType)
            }
            list = list.size > filter.count ? list[0..(filter.count - 1)] : list

            filter.resultsCount = list.size()
            if (!filter.save(flush: true))
                println filter.errors

            questions.addAll(list)
        }
    }

    def createExam(RandomExamTemplate template, Applicant applicant) {

        def examSheet = new ExamSheet(examTemplate: template, applicant: applicant)
        examSheet.save(flush: true)

        def filters = QuestionFilter.findAllByExamTemplateAndDeleted(template, false)
        def questions = []
        filters.each { filter ->

            def list = QuestionTopic.createCriteria().list {
                'in'('topic', [filter.topic] + filter.topic.allChildren)
                question {
                    eq('difficulty', filter.difficulty)
                }
                projections {
                    property('question')
                }
            }
            list = list.findAll {
                !questions.contains(it) &&
                        it.toString().contains(filter.questionType)
            }
            Collections.shuffle(list)
            list = list.size > filter.count ? list[0..(filter.count - 1)] : list

            questions.addAll(list)
        }


        def index = 1

        //multiple choice
        def qList = questions.findAll { it.toString().contains('MultipleChoiceQuestion') }
        Collections.shuffle(qList)
        qList.each { Question question ->
            Answer answer = new MultipleChoiceAnswer()
            answer.examSheet = examSheet
            answer.question = question
            answer.sequence = index++
            if (!answer.save(flush: true))
                println answer.errors
        }

        //short answer
        qList = questions.findAll { it.toString().contains('ShortAnswerQuestion') }
        Collections.shuffle(qList)
        qList.each { Question question ->
            Answer answer = new TextAnswer()
            answer.examSheet = examSheet
            answer.question = question
            answer.sequence = index++
            if (!answer.save(flush: true))
                println answer.errors
        }

        //file upload
        qList = questions.findAll { it.toString().contains('FileQuestion') }
        Collections.shuffle(qList)
        qList.each { Question question ->
            Answer answer = new FileAnswer()
            answer.examSheet = examSheet
            answer.question = question
            answer.sequence = index++
            if (!answer.save(flush: true))
                println answer.errors
        }

        examSheet.save(flush: true)
    }
}
