package codxam

import codxam.examTemplates.RandomExamTemplate

class ApplicationController {

    def questionFilterService

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

        def examTemplate = RandomExamTemplate.findByUniqueId(params.exam.code)

        def examSheet = questionFilterService.createExam(examTemplate, applicant)

        redirect(controller: 'exam', action: 'take', id: examSheet.id)
    }
}
