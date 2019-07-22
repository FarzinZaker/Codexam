package codxam.questions

class QuestionChoice {

    String name
    MultipleChoiceQuestion question
    Integer displayOrder
    Boolean correctAnswer = false

    Date dateCreated
    Date lastUpdated
    Boolean deleted = false

    static constraints = {
        name maxSize: 1000
        question nullable: true
        displayOrder nullable: true
    }
}
