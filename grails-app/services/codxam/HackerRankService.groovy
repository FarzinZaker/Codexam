package codxam

import codxam.external.ExternalQuestion
import codxam.external.ExternalQuestionChoice
import codxam.external.ExternalQuestionTag
import grails.gorm.transactions.Transactional
import org.openqa.selenium.By
import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.chrome.ChromeOptions
import org.openqa.selenium.interactions.Action
import org.openqa.selenium.interactions.Actions

//@Transactional
class HackerRankService {

    def grailsApplication

    ChromeDriver getBrowserInstance() {
//        "pkill -a -i \"Google Chrome\"".execute()

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
        try {
            if (browser.findElementsByClassName('auth-form').size() > 0)
                browser.findElementById('email').sendKeys(grailsApplication.config.hackerRank.username)
            browser.findElementById('password').sendKeys(grailsApplication.config.hackerRank.password)
            browser.findElementByClassName('signupBtn').click()
            Thread.sleep(15000)
        }
        catch (Exception ex) {
            println ex.message
        }
    }

    def extractQuestionList() {

        ChromeDriver browser = browserInstance
        def libraryUrl = 'https://www.hackerrank.com/work/library/hackerrank?page=1&view=question'
        browser.get(libraryUrl)
        login(browser)

        def finished = false
        while (!finished) {
            def count = browser.findElementByClassName('library-container')?.findElements(By.className('library-card'))?.size()
            for (def i = 0; i < count; i++) {
                try {
                    def id
                    def type
                    ExternalQuestion.withNewTransaction {
                        def card = browser.findElementByClassName('library-container')?.findElements(By.className('library-card'))[i]
                        type = card.findElements(By.className('light-meta'))?.find()?.text
                        if (type == 'Multiple Choice') {
                            def question = new ExternalQuestion(
                                    source: 'HackerRank',
                                    code: card.findElements(By.tagName('input'))?.find {
                                        it.getAttribute('type') == 'checkbox'
                                    }?.getAttribute('value')?.trim() ?: '0',
                                    name: card.findElements(By.className('title '))?.find()?.findElements(By.tagName('div'))?.find()?.text?.trim(),
                                    imported: false
                            )
                            question.url = "https://www.hackerrank.com/work/library/hackerrank?question=${question.code}&view=question"
                            question.save(flush: true)

                            def element = card.findElements(By.className('title '))?.find()?.findElements(By.tagName('div'))?.find()
                            Actions builder = new Actions(browser);
                            Action action = builder.moveToElement(element, 5, 5).click().build();
                            action.perform()

                            Thread.sleep(5000)

                            //extract details
                            def container = browser.findElementByClassName('library-card-view')

                            question.type = container.findElements(By.className('question-type'))?.find()?.text
                            question.difficulty = container.findElements(By.className('level-tag'))?.find()?.text
                            question.timeLimit = container.findElements(By.className('meta-item'))?.find {
                                it.getAttribute('data-automation') == 'question-recommended-time'
                            }?.text?.replace('Recommended Duration: ', '')?.replace('mins', '')?.replace('min', '')?.trim()?.toInteger()
                            question.score = container.findElements(By.className('meta-item'))?.find {
                                it.text?.contains('Points: ')
                            }?.text?.trim()?.replace('Points: ', '')?.toInteger()
                            question.body = container.findElements(By.className('question'))?.find()?.getAttribute("innerHTML")
                            id = question.save(flush: true).id
                        }
                    }

                    if (type == 'Multiple Choice') {
                        ExternalQuestion.withNewTransaction {
                            def question = ExternalQuestion.get(id)
                            def container = browser.findElementByClassName('library-card-view')
                            container.findElements(By.className('tags')).each {
                                def tag = ExternalQuestionTag.findByName(it.text)
                                if (!tag) {
                                    tag = new ExternalQuestionTag(name: it.text)
                                    tag.save()
                                }
                                question.addToTags(tag)
                            }
                            question.save(flush: true)

                            if (question.type == 'Multiple Choice' || question.type == 'Multiple Answers') {
                                def choicesContainer = container.findElements(By.className('answers'))?.find()
                                def indexer = 1
                                choicesContainer.findElements(By.tagName('input'))?.findAll {
                                    it.getAttribute('type') == 'radio'
                                }?.each { radio ->
                                    def choice = new ExternalQuestionChoice(
                                            title: radio.getAttribute('label'),
                                            correctAnswer: radio.getAttribute('checked') ?: false,
                                            displayOrder: indexer++,
                                            question: question
                                    )
                                    choice.save()
                                }
                            }
                            question.save(flush: true)
                        }
                    }
                } catch (Exception ex) {
                    Thread.sleep(5000)
                }
            }
            def nextButton = browser.findElementByClassName('next-page')
            if (nextButton.getAttribute('class').contains('disabled'))
                finished = true
            else {
                nextButton.click()
                Thread.sleep(5000)
            }
        }

        browser.close()
    }

    def extractQuestions() {
        ChromeDriver browser = browserInstance
        def libraryUrl = 'https://www.hackerrank.com/work/library/hackerrank'
        browser.get(libraryUrl)
        login(browser)

        ExternalQuestion.findAllBySourceAndImported('HackerRank', false).each { question ->
            browser.get(question.url)
            def container = browser.findElementByClassName('library-card-view')

            question.type = container.findElement(By.className('question-type')).text
            question.difficulty = container.findElement(By.className('level-tag')).text
            question.timeLimit = container.findElements(By.className('meta-item')).find {
                it.getAttribute('data-automation') == 'question-recommended-time'
            }?.text?.replace('Recommended Duration: ', '')?.replace('mins', '')?.replace('min', '')?.trim()?.toInteger()
            question.score = container.findElements(By.className('meta-item')).find {
                it.text?.contains('Points: ')
            }?.text?.trim()?.replace('Points: ', '')?.toInteger()
            question.body = container.findElement(By.className('question')).getAttribute("innerHTML")
            question.imported = true

            container.findElements(By.className('tags')).each {
                def tag = ExternalQuestionTag.findByName(it.text)
                if (!tag) {
                    tag = new ExternalQuestionTag(name: it.text)
                    tag.save()
                }
                question.addToTags(tag)
            }
            question.save()

            if (question.type == 'Multiple Choice') {
                def choicesContainer = container.findElement(By.className('answers'))
                def indexer = 1
                choicesContainer.findElements(By.tagName('input'))?.findAll {
                    it.getAttribute('type') == 'radio'
                }?.each { radio ->
                    def choice = new ExternalQuestionChoice(
                            title: radio.getAttribute('label'),
                            correctAnswer: radio.getAttribute('disabled'),
                            displayOrder: indexer++,
                            question: question
                    )
                    choice.save()
                }
            }

            question.save(flush: true)
        }
    }
}
