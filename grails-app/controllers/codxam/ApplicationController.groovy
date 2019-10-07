package codxam

import codxam.examTemplates.RandomExamTemplate
import grails.util.Environment

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
        if (!Environment.isDevelopmentMode()) {

            if (!recaptchaService.verifyAnswer(session, request.getRemoteAddr(), params)) {
                flash.message = "Captcha is not validated."
                redirect(action: 'apply', id: params.exam.code)
                return
            }

            if (ExamSheet.createCriteria().list {
                applicant {
                    eq('deleted', false)
                    or {
                        eq('email', params.email)
                        eq('skype', params.skype)
                    }
                }
                examTemplate {
                    eq('uniqueId', params.exam.code)
                }
            }.size()) {
                flash.message = "You have already taken this test. Each candidate can take the test only once."
                redirect(action: 'apply', id: params.exam.code)
                return
            }
        }

        def examSheet = null
        while (!examSheet) {
            def applicant = new Applicant(params)
            if (params.cv) {
                applicant.cv = params.cv.bytes
                applicant.cvFormat = params.cv.contentType
                applicant.cvName = params.cv.filename
            }
            applicant.email = applicant?.email?.toLowerCase()
            applicant.skype = applicant?.skype?.toLowerCase()
            applicant.save()

            def examTemplate = RandomExamTemplate.findByUniqueId(params.exam.code)

            examSheet = questionFilterService.createExam(examTemplate, applicant)
        }
        redirect(controller: 'exam', action: 'take', id: examSheet.id)
    }
}
