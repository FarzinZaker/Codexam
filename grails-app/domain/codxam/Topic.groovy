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

    transient String getFullName() {
        (parent ? "${parent.fullName} ❯ " : '') + name
    }

    transient List<Topic> getAllChildren() {
        def list = []
        list.addAll(children.findAll { !it.deleted })
        children.findAll { !it.deleted }?.each { Topic child ->
            list.addAll(child.allChildren)
        }
        list
    }
}
