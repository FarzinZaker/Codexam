package codxam

class ExamSheet {

    String startDate
    String endDate
    Integer currentQuestionIndex

    ExamTemplate examTemplate
    Applicant applicant

    Date dateCreated
    Date lastUpdated
    Boolean deleted = false

    static constraints = {
        currentQuestionIndex nullable: true
        startDate nullable: true
        endDate nullable: true
    }
}
