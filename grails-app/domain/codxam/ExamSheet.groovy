package codxam

class ExamSheet {

    String startDate
    String endDate

    ExamTemplate examTemplate
    Applicant applicant

    Date dateCreated
    Date lastUpdated
    Boolean deleted = false

    static constraints = {
        startDate nullable: true
        endDate nullable: true
    }
}
