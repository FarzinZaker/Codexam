{
    text: "${topic.name}",
    value: ${topic.id},
    expanded: true,
<g:if test="${topic.children?.findAll { !it.deleted }?.size()}">
    items: [
    <g:each in="${topic.children.findAll { !it.deleted }.sort { it.name }}" var="child">
        <g:render template="/topic/selectorOption" model="${[topic: child]}"/>
    </g:each>
    ]
</g:if>
},