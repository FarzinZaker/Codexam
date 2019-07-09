<%@ page import="codxam.User; codxam.Topic; codxam.Roles" %>
<div class="menuContainer">
    <ul id="menu">
        <li>
            Dimensions
            <ul>
                <li>
                    <a href="${createLink(controller: 'difficulty', action: 'list')}">Difficulty Levels</a>
                </li>
                <li>
                    <a href="${createLink(controller: 'topic', action: 'list')}">Test Topics</a>
                </li>
            </ul>
        </li>
        <li>
            Questions
            <ul>
                <g:each in="${Topic.findAllByParentIsNullAndDeleted(false).sort { it.name }}" var="topic">
                    <g:render template="/layouts/topicMenu" model="${[topic: topic]}"/>
                </g:each>
            </ul>
        </li>
        <li>
            Exams
            <ul>
                <li>
                    <a href="${createLink(controller: 'examTemplate', action: 'list')}">Templates</a>
                </li>
                <li>
                    <a href="${createLink(controller: 'exam', action: 'list')}">Running</a>
                </li>
            </ul>
        </li>
        <li>
            User Management
            <ul>
                <g:each in="${Roles.ALL}" var="role">
                    <li>
                        <a href="${createLink(controller: 'user', action: 'list', id: role)}">
                            <g:message code="${role}.list"/>
                        </a>
                    </li>
                </g:each>
            </ul>
        </li>
        <sec:ifNotLoggedIn>
            <li class="userMenu">
                <a href="${createLink(controller: 'login')}">Login</a>
            </li>
        </sec:ifNotLoggedIn>
        <sec:ifLoggedIn>
            <li class="userMenu">
                ${User.findByUsername(sec.username())?.toString()}
                <ul>
                    <li>
                        <a href="${createLink(controller: 'user', action: 'changePassword')}">Change Password</a>
                    </li>
                    <li>
                        <a href="${createLink(controller: 'logout')}">Logout</a>
                    </li>
                </ul>
            </li>
        </sec:ifLoggedIn>
    </ul>
</div>
<script>
    $(document).ready(function () {
        $("#menu").kendoMenu();
    });
</script>