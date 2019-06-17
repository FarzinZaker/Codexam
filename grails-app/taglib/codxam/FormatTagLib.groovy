package codxam

class FormatTagLib {
    static defaultEncodeAs = [taglib:'text']

    static namespace = "format"

    def html = { attrs, body ->
        out << attrs.value
    }
}

