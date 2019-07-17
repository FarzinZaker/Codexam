package codxam

import grails.converters.JSON
import grails.core.GrailsApplication
import grails.plugin.springsecurity.annotation.Secured
import groovy.io.FileType

import java.text.DateFormat
import java.text.SimpleDateFormat

@Secured([Roles.ADMIN, Roles.EXAMINER])
class ImageController {

    GrailsApplication grailsApplication

    def upload() {
        def fileName = params.file.originalFilename
        def path = "${grailsApplication.config.images.path}/${fileName}"
        def file = new File(path)

        def directory = file.parentFile
        if (!directory.exists())
            directory.mkdirs()

        if (file.exists())
            file.delete()

        params.file.transferTo(file)

        file = new File(path)

        render([location: createLink(controller: 'image', action: 'get', id: file.name)] as JSON)

    }

    def get() {
        def path = "${grailsApplication.config.images.path}/${params.id}${params.format ? '.' + params.format : ''}"
        def content = null
        try {
            path = new File(path)
            content = path?.getBytes()
        } catch (ignored) {
        }
        if (content) {
            def seconds = 3600 * 24
            DateFormat httpDateFormat = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss z", Locale.US);
            httpDateFormat.setTimeZone(java.util.TimeZone.getTimeZone("GMT"));
            Calendar cal = new GregorianCalendar();
            cal.add(Calendar.SECOND, seconds);
            response.setHeader("Cache-Control", "PUBLIC, max-age=" + seconds + ", must-revalidate");
            response.setHeader("Expires", httpDateFormat.format(cal.getTime()));
            response.contentType = 'image/png'
            response.setStatus(200)
            response.outputStream << content
            response.outputStream.flush()
        } else
            render ""
    }
}
