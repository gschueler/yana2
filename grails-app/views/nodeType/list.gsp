
<%@ page import="com.dtolabs.NodeType" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'nodeType.label', default: 'NodeType')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>

		<div id="list-nodeType" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			
			<g:if test="${nodeTypeInstanceList}">
			<table class="table table-striped table-hover">
				<tbody>
				<g:each in="${nodeTypeInstanceList}" status="i" var="nodeTypeInstance">
					<tr>
						<td style="width: 20px">
						<img src="${resource(dir:path,file:nodeTypeInstance.image)}" alt="" style="vertical-align:middle;"/></td>
						<td ><g:link action="show" id="${nodeTypeInstance.id}">${fieldValue(bean: nodeTypeInstance, field: "name")}</g:link></td>
						<g:if test="${nodeTypeInstance.description?.size()>50}">
						<td >${nodeTypeInstance.description[0..50]}...</td>
						</g:if>
						<g:else>
						<td >${nodeTypeInstance.description}</td>
						</g:else>
						<td>
                            <g:link action="index" controller="search"

                                                               params="${[q: 'nodetype:' + nodeTypeInstance.name]}">${com.dtolabs.Node.countByNodetype(nodeTypeInstance)} Nodes <i class="icon-search"></i></g:link></td>
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${nodeTypeInstanceTotal}" />
			</div>
			</g:if>
			<g:else>

                <div class="hero-unit">

                    <p>This project has no node types: use the Import tool to load your initial structure.</p>

                    <p>
                        <g:link controller="import" action="importxml"
                                class="btn btn-primary btn-large">Import</g:link>
                    </p>
                </div>
			</g:else>
		</div>
	</body>
</html>
