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


    <div class="">

        <sec:ifAnyGranted roles="ROLE_YANA_ADMIN,ROLE_YANA_SUPERUSER">
            <div class="btn-group">
                <g:link action="create" class="btn btn-primary">
                    <g:message code="default.create.label" args="[entityName]"/>
                    <i class="icon-plus icon-white"></i>
                </g:link>
            </div>
        </sec:ifAnyGranted>

    <g:if test="${projects}">
        <table class="table table-striped table-hover table-bordered">
        <g:each in="${projects}" status="i" var="project">
            <tr id="proj_${i}">
                <td class="item_title">
                    <g:link action="select" params="${[project:project.name]}">
                        ${project.name.encodeAsHTML()}
                    </g:link>
                </td>
                <td class="item_desc">
                    <g:if test="${project.description?.size() > 50}">${project.description[0..50].encodeAsHTML()}...</g:if>
                    <g:else>${project.description.encodeAsHTML()}</g:else>
                </td>
                <td class="">
                    <sec:permitted className='com.dtolabs.Project' id='${project.id}' permission='delete,administration'>
                            <div class="modal hide " id="deleteConfirm${i}" tabindex="-1" role="dialog"
                                 aria-labelledby="myModalLabel${i}" aria-hidden="true">

                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"
                                        aria-hidden="true">&times;</button>

                                <h3 id="myModalLabel${i}">Delete Project <strong>${project.name.encodeAsHTML()}</strong>?</h3>
                            </div>

                            <div class="modal-body">

                                <div class="well well-small">
                                    Click here to
                                    <g:link controller="export" action="xml" params="${[project: project.name]}"
                                            class="btn btn-small">Export XML</g:link>
                                </div>

                            </div>

                            <div class="modal-footer">
                                <g:form action="delete">
                                    <g:hiddenField name="name" value="${project.name}"/>
                                    <a href="#" data-dismiss="modal" class="btn" aria-hidden="true">No</a>
                                    <g:submitButton name="Yes Delete It" class="btn btn-danger"/>
                                </g:form>
                            </div>
                        </div>
                    </sec:permitted>
                    <div class="btn-group pull-right">
                    <sec:permitted className='com.dtolabs.Project' id='${project.id}' permission='delete,administration'>

                        <input type="button" data-toggle="modal" data-target="#deleteConfirm${i}" value="Delete"
                               class="btn btn-danger btn-small"/>


                    </sec:permitted>
                    <sec:permitted className='com.dtolabs.Project' id='${project.id}' permission='administration'>
                            <g:link  class="btn btn-small" action="editAdmin" params="${[name:project.name]}">Admin</g:link>
                    </sec:permitted>
                    </div>
                </td>
            </tr>
        </g:each>
        </table>

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
