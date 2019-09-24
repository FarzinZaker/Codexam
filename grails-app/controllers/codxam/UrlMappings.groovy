package codxam

class UrlMappings {

    static mappings = {
        "/exam/take/$id?/$question?"(controller: 'exam', action: 'take')
        "/$controller/$action?/$id?(.$format)?" {
            constraints {
                // apply constraints here
            }
        }

        "/"(controller: "examTemplate", action: "list")
        "500"(view: '/error')
        "404"(view: '/notFound')
    }
}
