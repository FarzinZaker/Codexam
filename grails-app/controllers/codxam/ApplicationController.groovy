package codxam

class ApplicationController {

    def intro() {
        [examTemplate: ExamTemplate.findByUniqueId(params.id)]
    }

    def apply() {
        [examTemplate: ExamTemplate.findByUniqueId(params.id)]
    }

    def saveApplication() {
        def applicant = new Applicant(params)
        if (params.cv) {
            applicant.cv = params.cv.bytes
            applicant.cvFormat = params.cv.contentType
        }
        applicant.save()

        def examTemplate = ExamTemplate.findByUniqueId(params.exam.code)

        def examSheet = new ExamSheet(examTemplate: examTemplate, applicant: applicant)
        examSheet.save(flush: true)

        redirect(controller: 'exam', action: 'take', id: examSheet.id)
    }
}
