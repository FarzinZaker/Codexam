package codxam

class Answer {

    ExamSheet examSheet
    Question question
    Date startDate
    Date endDate
    String ipAddress
    Integer sequence

    Integer mark

    Date dateCreated
    Date lastUpdated
    Boolean deleted = false

    static constraints = {
        startDate nullable: true
        endDate nullable: true
        mark nullable: true
        ipAddress nullable: true
    }
}
