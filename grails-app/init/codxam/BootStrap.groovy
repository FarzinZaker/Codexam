package codxam

class BootStrap {

    def init = { servletContext ->


        //Users & Roles
        Roles.ALL.each { authority ->
            def role = Role.findByAuthority(authority)
            if (!role)
                new Role(authority: authority).save()
        }

        def admin = User.findByUsername('admin')
        if (!admin)
            admin = new User(username: 'admin', password: 'Neters11@@', firstName: 'System', lastName: 'Administrator')

        admin.accountLocked = false
        admin.accountExpired = false
        admin.passwordExpired = false
        admin.enabled = true
        admin.save()

        def adminRole = Role.findByAuthority(Roles.ADMIN)

        if (!UserRole.findByUserAndRole(admin, adminRole))
            new UserRole(user: admin, role: adminRole).save()


        //Countries
        if (Country.countByDeleted(false) == 0) {
            def resource = this.class.classLoader.getResource('countries.csv')
            def path = resource.file
            new File(path).eachLine { line ->
                new Country(name: line.trim()).save()
            }
        }

        //TimeZones
        if (TimeZone.countByDeleted(false) == 0) {
            def resource = this.class.classLoader.getResource('timeZones.csv')
            def path = resource.file
            new File(path).eachLine { line ->
                def parts = line.split(',')
                new TimeZone(name: parts[0].trim(), location: parts[2].trim(), difference: parts[1].trim()).save()
            }
        }
    }
    def destroy = {
    }
}
