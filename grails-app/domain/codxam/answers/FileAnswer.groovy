package codxam.answers

import codxam.Answer

class FileAnswer extends Answer {

    byte[] file
    String fileFormat
    String fileName

    static mapping = {
        file sqlType: 'bytea'
    }

    static constraints = {
        file nullable: true
        fileFormat nullable: true
        fileName nullable: true
    }

    transient boolean getAnswered() {
        file
    }
}
