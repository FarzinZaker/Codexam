<ul>
    <g:each in="${errors}" var="error">
        <li>${error.toString()?.split(';')?.find()}</li>
    </g:each>
</ul>