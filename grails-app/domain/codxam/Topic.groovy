package codxam

class Topic {

    String name

    Date dateCreated
    Date lastUpdated
    Boolean deleted = false

    static constraints = {
        name()
    }
}
