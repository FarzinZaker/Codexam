package codxam.external

class ExternalQuestion {

    String source
    String code
    String name
    String url
    Boolean imported = false
    Integer timeLimit
    Integer score
    String type
    String difficulty
    String body

    static belongsTo = [ExternalQuestionTag]

    static hasMany = [choices: ExternalQuestionChoice, tags: ExternalQuestionTag]

    static mapping = {
        body sqlType: 'Text'
    }

    static constraints = {
        imported nullable: true
        score nullable: true
        type nullable: true
        difficulty nullable: true
        timeLimit nullable: true
        body nullable: true
    }
}
