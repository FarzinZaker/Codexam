package codxam

class ExamTemplate {

    String name

    String uniqueId

    Date dateCreated
    Date lastUpdated
    Boolean deleted = false

    static constraints = {
        uniqueId nullable: true
    }

    def beforeInsert() {
        generateUniqueId()
    }

    def beforeUpdate() {
        generateUniqueId()
    }

    private generateUniqueId() {
        if (!uniqueId) {
            def generator = { String alphabet, int n ->
                new Random().with {
                    (1..n).collect { alphabet[nextInt(alphabet.length())] }.join()
                }
            }

            uniqueId = generator((('a'..'z') + ('0'..'9')).join(), 9)
        }
    }
}
