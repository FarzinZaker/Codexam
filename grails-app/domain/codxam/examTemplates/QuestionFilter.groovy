package codxam.examTemplates

import codxam.Difficulty
import codxam.Topic

class QuestionFilter {

    Topic topic
    RandomExamTemplate examTemplate
    Integer count
    Difficulty difficulty
    String questionType
    Integer resultsCount

    Date dateCreated
    Date lastUpdated
    Boolean deleted = false

    static constraints = {
        resultsCount nullable: true
    }

    transient Boolean getIsValid() {
        if (!resultsCount)
            return false
        resultsCount >= count
    }
}
