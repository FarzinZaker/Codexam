package codxam.answers

import codxam.Answer

class TextAnswer extends Answer {

    String body

    static mapping = {
        body sqlType: 'Text'
    }

    static constraints = {
        body nullable: true
    }

    transient boolean getAnswered() {
        body?.trim()
    }
}
