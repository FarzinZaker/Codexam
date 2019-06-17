package codxam.questions

import codxam.Question

class MultipleChoiceQuestion extends Question {

    QuestionChoice correctAnswer

    static hasMany = [choices: QuestionChoice]

    Date dateCreated
    Date lastUpdated
    Boolean deleted = false

    static constraints = {
        correctAnswer nullable: true
    }
}
