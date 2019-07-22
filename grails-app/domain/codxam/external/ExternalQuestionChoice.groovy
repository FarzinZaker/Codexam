package codxam.external

class ExternalQuestionChoice {

    String title
    Boolean correctAnswer = false
    Integer displayOrder

    ExternalQuestion question

    static hasMany = [tags: ExternalQuestionTag]

    static constraints = {
        title maxSize: 1000
    }
}
