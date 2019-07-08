{
    text: "${topic.name}",
    value: ${topic.id},
    expanded: false,
<g:if test="${topic.children?.size()}">
    items: [
    <g:each in="${topic.children}" var="child">
        <g:render template="selectorOption" model="${[topic: child]}"/>
    </g:each>
    ]
</g:if>
},