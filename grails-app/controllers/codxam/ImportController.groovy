package codxam

import grails.plugin.springsecurity.annotation.Secured

@Secured([Roles.ADMIN])
class ImportController {

    def hackerRankService
    def importService

    def hackerRank() {
        hackerRankService.extractQuestionList()
        render 'DONE'
    }

    def importHackerRank() {
        importService.importHackerRank()
    }
}
