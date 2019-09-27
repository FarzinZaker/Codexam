package codxam

class ExamSheet {

    Date startDate
    Date endDate
    Integer currentQuestionIndex
    Integer totalTime

    ExamTemplate examTemplate
    Applicant applicant

    Date dateCreated
    Date lastUpdated
    Boolean deleted = false

    transient Integer getTotalScore() {
        Answer.findAllByExamSheetAndDeleted(this, false).sum { Answer answer -> answer.question.score ?: 1 } as Integer
    }

    transient Integer getTotalMark() {
        Answer.findAllByExamSheetAndDeleted(this, false).sum { Answer answer -> answer.mark ?: 0 } as Integer
    }

    transient Integer getMarkedScore() {
        Answer.findAllByExamSheetAndDeleted(this, false).findAll{it.mark != null || !it.answered}.sum { Answer answer -> answer.question.score ?: 1 } as Integer
    }

    transient Integer getMarkedMark() {
        Answer.findAllByExamSheetAndDeleted(this, false).findAll{it.mark != null || !it.answered}.sum { Answer answer -> answer.mark ?: 0 } as Integer
    }

    transient List<Answer> getUnAnsweredList() {
        Answer.findAllByExamSheetAndDeleted(this, false).findAll { !it.answered }
    }

    transient List<Answer> getUnMarkedList() {
        Answer.findAllByExamSheetAndDeleted(this, false).findAll { it.answered && it.mark == null }
    }

    transient List<Answer> getCorrectList() {
        Answer.findAllByExamSheetAndDeleted(this, false).findAll { it.answered && it.mark > 0 }
    }

    transient List<Answer> getIncorrectList() {
        Answer.findAllByExamSheetAndDeleted(this, false).findAll { it.answered && it.mark == 0 }
    }

    static constraints = {
        currentQuestionIndex nullable: true
        startDate nullable: true
        endDate nullable: true
        totalTime nullable: true
    }
}
