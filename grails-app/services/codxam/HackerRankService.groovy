package codxam

import grails.gorm.transactions.Transactional

@Transactional
class HackerRankService {

    def grailsApplication

    ChromeDriver getBrowserInstance() {
        "pkill -a -i \"Google Chrome\"".execute()

        System.setProperty('webdriver.chrome.driver', grailsApplication.config.selenium.chrome.driver)
        try {
            def options = new ChromeOptions()
//        options.addArguments('--headless')
//        options.addArguments('--no-sandbox')
//        options.addArguments('--disable-dev-shm-usage')
            options.addArguments("user-data-dir=${grailsApplication.config.selenium.chrome.dataFolder}")
            def browser = new ChromeDriver(options)
            browser.manage().window().maximize()
            browser
        }
        catch (Exception ex) {
            Thread.sleep(10000)
            browserInstance
        }
    }

    private login(ChromeDriver browser) {

        def gitHubURL = 'https://www.hackerrank.com/work/library/hackerrank'
        def gitHubUsername = ''
        def gitHubPassword = 'Retan112233'

        browser.get(gitHubURL)

        if (firstRepository) {
            try {
                browser.findElementById('login_field').sendKeys(gitHubUsername)
                browser.findElementById('password').sendKeys(gitHubPassword)
                browser.findElementByName('commit').click()
                Thread.sleep(15000)
            }
            catch (Exception ex) {
                println ex.message
            }
            firstRepository = false;
        }
    }

    def listQuestions(String libraryUrl) {

    }
}
