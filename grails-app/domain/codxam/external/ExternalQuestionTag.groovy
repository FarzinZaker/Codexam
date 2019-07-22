package codxam.external

class ExternalQuestionTag {

    String name

    static hasMany = [questions: ExternalQuestion]

    static constraints = {
    }
}
