
<%@ page import="com.dtosolutions.Webhook" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'webhook.label', default: 'Webhook')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>

		<div id="list-webhook" class="list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
						<g:sortableColumn property="url" title="${message(code: 'webhook.user.label', default: 'User')}" />
						<g:sortableColumn property="url" title="${message(code: 'webhook.url.label', default: 'Url')}" />
						<g:sortableColumn property="attempts" title="${message(code: 'webhook.attempts.label', default: 'Attempts')}" />
						<g:sortableColumn property="format" title="${message(code: 'webhook.format.label', default: 'Format')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${webhookInstanceList}" status="i" var="webhookInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
						<td><g:link controller="user" action="show" id="${webhookInstance.user.id}">${webhookInstance.user.id}</g:link></td>
						<td><g:link action="show" id="${webhookInstance.id}">${fieldValue(bean: webhookInstance, field: "url")}</g:link></td>
						<td><g:link action="show" id="${webhookInstance.id}">${fieldValue(bean: webhookInstance, field: "attempts")}</g:link></td>
						<td><g:link action="show" id="${webhookInstance.id}">${fieldValue(bean: webhookInstance, field: "format")}</g:link></td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${webhookInstanceTotal}" />
			</div>
		</div>
	</body>
</html>
