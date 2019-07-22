package codxam.questions

import codxam.Question

class MultipleChoiceQuestion extends Question {

    static hasMany = [choices: QuestionChoice]

    Date dateCreated
    Date lastUpdated
    Boolean deleted = false

    static constraints = {
    }
}
