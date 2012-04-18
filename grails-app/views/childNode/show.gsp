
<%@ page import="com.dtosolutions.ChildNode" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'childNode.label', default: 'ChildNode')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>

		<div id="show-childNode" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list childNode">
			
				<g:if test="${childNodeInstance?.relationshipName}">
				<li class="fieldcontain">
					<span id="relationshipName-label" class="property-label"><g:message code="childNode.relationshipName.label" default="Relationship Name" /></span>
					
						<span class="property-value" aria-labelledby="relationshipName-label"><g:fieldValue bean="${childNodeInstance}" field="relationshipName"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${childNodeInstance?.parent}">
				<li class="fieldcontain">
					<span id="parent-label" class="property-label"><g:message code="childNode.parent.label" default="Parent" /></span>
					
						<span class="property-value" aria-labelledby="parent-label"><g:link controller="node" action="show" id="${childNodeInstance?.parent?.id}">${childNodeInstance?.parent?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
				<g:if test="${childNodeInstance?.child}">
				<li class="fieldcontain">
					<span id="child-label" class="property-label"><g:message code="childNode.child.label" default="Child" /></span>
					
						<span class="property-value" aria-labelledby="child-label"><g:link controller="node" action="show" id="${childNodeInstance?.child?.id}">${childNodeInstance?.child?.encodeAsHTML()}</g:link></span>
					
				</li>
				</g:if>
			
			</ol>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${childNodeInstance?.id}" />
					<g:link class="edit" action="edit" id="${childNodeInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>