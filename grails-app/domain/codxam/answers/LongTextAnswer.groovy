package codxam.answers

import codxam.Answer

class LongTextAnswer extends Answer {

    String body

    static mapping = {
        body sqlType: 'Text'
    }

    static constraints = {

    }
}
