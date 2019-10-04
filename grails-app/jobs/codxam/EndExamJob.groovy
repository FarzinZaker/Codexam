package codxam

import groovy.time.TimeCategory

class EndExamJob {
    static triggers = {
        simple repeatInterval: 5000l // execute job once in 5 seconds
    }

    static concurrent = false

    def execute() {
        ExamSheet.findAllByEndDateIsNullAndTotalTimeIsNotNull().each { examSheet ->
            if (examSheet.totalTime) {
                use(TimeCategory) {
                    Date expectedEndDate = examSheet.startDate + (examSheet.totalTime).minutes
                    if (expectedEndDate < new Date()) {
                        println expectedEndDate
                        println new Date()
                        println expectedEndDate < new Date()
                        examSheet.endDate = expectedEndDate
                        examSheet.save(flush: true)
                    }
                }
            }
        }
    }
}
