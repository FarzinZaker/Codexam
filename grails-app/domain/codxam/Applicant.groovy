package codxam

class Applicant {

    String firstName
    String lastName
    String email
    String skype
    Country country
    TimeZone timeZone
    byte[] cv
    String cvFormat
    String cvName

    static mapping = {
        cv sqlType: 'bytea'
    }

    static constraints = {
        skype nullable: true
        cv nullable: true
        cvFormat nullable: true
        cvName nullable: true
    }
}
