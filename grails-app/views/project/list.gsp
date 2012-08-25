<%--
  Copyright 2012 DTO Labs, Inc. (http://dtolabs.com)

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
 
 --%>
<%--
   list.gsp

   Author: Greg Schueler <a href="mailto:greg@dtosolutions.com">greg@dtosolutions.com</a>
   Created: 7/25/12 5:22 PM
--%>


<%@ page import="com.dtolabs.Project" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${g.message(code: 'project.label', default: 'Project')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>

<div id="list-node" role="main" class="span8 offset2">
    <div class="page-header">
        <h1><g:message code="default.list.label" args="[entityName]"/></h1>
    </div>

    <g:if test="${flash.message}">
        <div class="alert" role="status">${flash.message.encodeAsHTML()}</div>
    </g:if>
    <g:if test="${message}">
        <div class="alert" role="status">${message.encodeAsHTML()}</div>
    </g:if>


    <div class="well well-small">

        <sec:ifAnyGranted roles="ROLE_YANA_ADMIN,ROLE_YANA_SUPERUSER">
            <div class="">
                <g:link action="create" class="btn btn-success">
                    <g:message code="default.create.label" args="[entityName]"/>
                    <i class="icon-plus icon-white"></i>
                </g:link>
            </div>
        </sec:ifAnyGranted>

    <g:if test="${projects}">
        <ul>
        <g:each in="${projects}" status="i" var="project">
            <li id="proj_${i}">
                <span class="item_title">
                    <g:link action="select" params="${[project:project.name]}">
                        ${project.name.encodeAsHTML()}
                    </g:link>
                </span>
                <span class="item_desc">
                    <g:if test="${project.description?.size() > 50}">${project.description[0..50].encodeAsHTML()}...</g:if>
                    <g:else>${project.description.encodeAsHTML()}</g:else>
                </span>
                <sec:permitted className='com.dtolabs.Project' id='${project.id}' permission='delete,administration'>
                    <span class="deleteConfirm">
                        <input type="button" onclick="$('#proj_${i} .deleteConfirm').toggle()" value="Delete"
                               class="btn btn-danger btn-small"/>
                    </span>
                    <div class="deleteConfirm" style="display:none">
                        <span>Really delete project ${project.name.encodeAsHTML()}?</span>
                        <g:form action="delete">
                            <g:hiddenField name="name" value="${project.name}"/>
                            <input  class="btn btn-small" type="button" onclick="$('#proj_${i} .deleteConfirm').toggle();return false" value="No"/>
                            <g:submitButton name="Yes" class="btn btn-danger btn-small"/>
                        </g:form>
                    </div>
                </sec:permitted>
                <sec:permitted className='com.dtolabs.Project' id='${project.id}' permission='administration'>
                    <span>
                        <g:link  class="btn btn-small" action="editAdmin" params="${[name:project.name]}">Admin</g:link>
                    </span>
                </sec:permitted>
            </li>
        </g:each>
        </ul>

        <div class="pagination">
            %{--<g:paginate total="${nodeInstanceTotal}"/>--}%
        </div>
    </g:if>
    <g:else>
        <span style="padding:25px;">
            <h4>No Projects available, please create a new Project</h4>
        </span>
    </g:else>
    </div>
</div>
</body>
</html>
