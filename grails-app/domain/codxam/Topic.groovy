package codxam

class Topic {

    String name
    Topic parent

    Date dateCreated
    Date lastUpdated
    Boolean deleted = false

    static hasMany = [children: Topic]

    static constraints = {
        name()
    }
}
