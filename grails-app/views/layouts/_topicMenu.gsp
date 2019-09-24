<li>
    <a href="${createLink(controller: 'question', action: 'list', id: topic.id)}">${topic.name}</a>
    <g:if test="${children && topic.children?.findAll { !it.deleted }?.size()}">
        <ul>
            <g:each in="${topic.children.findAll { !it.deleted }.sort { it.name }}" var="child">
                <g:render template="/layouts/topicMenu" model="${[topic: child]}"/>
            </g:each>
        </ul>
    </g:if>
</li>