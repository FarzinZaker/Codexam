package codxam

class Answer {

    ExamSheet examSheet
    Date startDate
    Date endDate
    String ipAddress

    Integer mark

    Date dateCreated
    Date lastUpdated
    Boolean deleted = false

    static constraints = {
        startDate nullable: true
        endDate nullable: true
        mark nullable: true
    }
}
