package codxam

import codxam.examTemplates.RandomExamTemplate

class ApplicationController {

    def questionFilterService
    def recaptchaService

    def intro() {
        [examTemplate: ExamTemplate.findByUniqueId(params.id)]
    }

    def apply() {
        [examTemplate: ExamTemplate.findByUniqueId(params.id)]
    }

    def saveApplication() {
        if (!recaptchaService.verifyAnswer(session, request.getRemoteAddr(), params)) {
            flash.message = "Captcha is not validated."
            redirect(action: 'apply', id: params.exam.code)
            return
        }
        def applicant = new Applicant(params)
        if (params.cv) {
            applicant.cv = params.cv.bytes
            applicant.cvFormat = params.cv.contentType
            applicant.cvName = params.cv.filename
        }
        applicant.save()

        def examTemplate = RandomExamTemplate.findByUniqueId(params.exam.code)

        def examSheet = questionFilterService.createExam(examTemplate, applicant)

        redirect(controller: 'exam', action: 'take', id: examSheet.id)
    }
}
