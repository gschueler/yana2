<%@ page import="com.dtolabs.Project" %>



<div class="control-group ${hasErrors(bean: project, field: 'name', 'error')} required">
    <label for="name" class="control-label">
        <g:message code="project.name.label" default="Name"/>
        <span class="required-indicator">*</span>
    </label>

    <div class="controls">
        <g:textField name="name" required="" value="${project?.name}"/>
    </div>
</div>

<div class="control-group  ${hasErrors(bean: project, field: 'description', 'error')} required">
    <label for="description" class="control-label">
        <g:message code="project.description.label" default="Description"/>
        <span class="required-indicator">*</span>
    </label>

    <div class="controls">
        <g:textArea name="description" rows="2" cols="50">${project?.description}</g:textArea>
    </div>
</div>
