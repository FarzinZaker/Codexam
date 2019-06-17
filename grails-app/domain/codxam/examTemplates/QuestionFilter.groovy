package codxam.examTemplates

import codxam.Difficulty
import codxam.Topic

class QuestionFilter {

    Topic topic
    RandomExamTemplate examTemplate
    Integer count
    Difficulty difficulty

    Date dateCreated
    Date lastUpdated
    Boolean deleted = false

    static constraints = {
    }
}
