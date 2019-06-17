package codxam.examTemplates

import codxam.ExamTemplate

class RandomExamTemplate extends ExamTemplate {

    static hasMany = [questionFilters: QuestionFilter]

    static constraints = {
    }
}
