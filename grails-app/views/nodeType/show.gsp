
<%@ page import="com.dtosolutions.NodeType" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'nodeType.label', default: 'NodeType')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>

	<div id="show-nodeType" class="content scaffold-show" role="main">
		<h1><g:message code="default.show.label" args="[entityName]" /></h1>
		<g:if test="${flash.message}">
		<div class="message" role="status">${flash.message}</div>
		</g:if>
			
		<g:if test="${nodeTypeInstance.image}">
		<img src="${resource(dir:path,file:nodeTypeInstance.image)}" alt="" style="vertical-align:middle;" /><span class="image-title"><g:fieldValue bean="${nodeTypeInstance}" field="name"/></span>
		</g:if>

		<table class="scaffold" border="0">
			
			<g:if test="${nodeTypeInstance?.description}">
			<tr>
					<td colspan=2 class="info"><g:fieldValue bean="${nodeTypeInstance}" field="description"/></td>
			</tr>
			</g:if>

			<tr>
				<td colspan=2>
					<h3>Attributes</h3>
					<div class="list" >
					<table width=375>
						<thead>
							<tr>
								<th style="text-align:center;font-weight:bold;">Name</th>
								<th style="text-align:center;font-weight:bold;">Datatype</th>
								<th style="text-align:center;font-weight:bold;">Required?</th>
							</tr>
						</thead>
						<tbody>
						<g:if test="${nodeTypeInstance?.attributes}">
							
							<g:each in="${com.dtosolutions.TemplateAttribute.findAllByTemplate(com.dtosolutions.NodeType.get(nodeTypeInstance?.id), [sort:'attribute.name',order:'asc'])}" status="i" var="t">
							<g:set var="attributeInstance" value="${com.dtosolutions.Attribute.findAllById(t?.attribute?.id, [sort:'name',order:'asc'])}" />
							

							<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
								<td>${attributeInstance.name[0]}</td>
								<td>${attributeInstance.filter.dataType[0]}</td>
								<td>${t.required.encodeAsHTML()}</td>
							</tr>
							</g:each>
						</g:if>
						</tbody>
					</table>
					</div>
			
				</td>
			</tr>
			<tr>
				<td>
					<table width=375>
						<thead>
							<tr>
								<td style="font: bold 11px verdana, arial, helvetica, sans-serif;"><g:message code="nodeType.dateCreated.label" default="Date Created" />: </td>
								<td style="font: 11px verdana, arial, helvetica, sans-serif;"><g:formatDate date="${nodeTypeInstance?.dateCreated}" /></td>
							</tr>
						
							<tr>
								<td style="font: bold 11px verdana, arial, helvetica, sans-serif;"><g:message code="nodeType.dateModified.label" default="Date Modified" />: </td>
								<td style="font: 11px verdana, arial, helvetica, sans-serif;"><g:formatDate date="${nodeTypeInstance?.dateModified}" /></td>
							</tr>
						</thead>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan=2>
					<g:form>
						<fieldset class="form_footer">
							<g:hiddenField name="id" value="${nodeTypeInstance?.id}" />
							<span class="fake_button"><g:link action="edit" id="${nodeTypeInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link></span>
							<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
						</fieldset>
					</g:form>
				</td>
			</tr>
		</table>
		</div>
	</body>
</html>
