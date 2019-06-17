package codxam

class Question {

    String title
    String body
    Difficulty difficulty
    Integer timeLimit
    Integer score

    Date dateCreated
    Date lastUpdated
    Boolean deleted = false

    static mapping = {
        body sqlType: 'Text'
    }

    static constraints = {
        title maxSize: 1000
        body()
        difficulty()
        timeLimit min: 0

    }
}
