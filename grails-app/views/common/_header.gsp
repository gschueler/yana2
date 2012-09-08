        <div class="navbar navbar-static-top">
            <div class="navbar-inner">
                <g:link class="brand" controller="node" action="index">Yana</g:link>
                <sec:ifLoggedIn>
                <ul class="nav">


                    <g:if test="${session.project}">
                        <li class="active"><g:link action="list" controller="project">Project ${session.project.encodeAsHTML()}</g:link></li>
                    </g:if>
                        <li class="dropdown">
                            <g:link controller="node" action="list" class="dropdown-toggle" data-toggle="dropdown" data-target="#">
                                Nodes

                                <b class="caret"></b>
                            </g:link>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                                <li><g:link controller="node" action="list">List</g:link></li>
                                <li><g:link controller="node" action="create">Create</g:link></li>
                                <!--
						<li class="current"><g:link controller="childNode" action="list">Node Relationships</g:link>
							<ul>
								<li class="current"><g:link controller="childNode"
                                                            action="create">Create Node Relationship</g:link></li>
							</ul>
						</li>
						-->
                            </ul>

                        </li>
                        <li class="dropdown">
                        <g:link controller="nodeType" action="list" class="dropdown-toggle" data-toggle="dropdown"
                                data-target="#">
                            Types

                            <b class="caret"></b>
                        </g:link>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                                <li><g:link controller="nodeType" action="list">NodeTypes</g:link>
                                <!--
							<ul>
								<li><g:link controller="nodeType" action="create">Create NodeType</g:link></li>
							</ul>
					  	 -->
                                </li>
                                <li><g:link controller="attribute" action="list">Attributes</g:link>
                                <!--
							<ul>
								<li><g:link controller="attribute" action="create">Create Attribute</g:link></li>
							</ul>
						  -->
                                </li>
                                <li><g:link controller="filter" action="list">Filters</g:link>
                                <!--
							<ul>
								<li><g:link controller="filter" action="create">Create Filter</g:link></li>
							</ul>
						  -->
                                </li>
                                <li><g:link controller="nodeTypeRelationship"
                                            action="list">Nodetype Relationship</g:link>
                                <!--
							<ul>
								<li><g:link controller="nodeTypeRelationship"
                                            action="create">Create Nodetype Relationship</g:link></li>
							</ul>
						 -->
                                </li>
                            </ul>
                        </li>

                        <li class="dropdown">
                        <a href="${grailsApplication.config.grails.serverURL}/import" class="dropdown-toggle"
                           data-toggle="dropdown" data-target="#">
                            Admin

                            <b class="caret"></b>
                        </a>
                            <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
                                <li><g:link controller="import" action="importxml">Import Model</g:link></li>
                                <li><g:link controller="export" action="xml">Export Model</g:link></li>

                                <li class="dropdown-submenu">
                                    <g:link controller="user" action="search" data-target="#">Users</g:link>
                                    <ul class="dropdown-menu">
                                        <li><g:link controller="user" action="create">Create User</g:link></li>
                                    </ul>
                                </li>
                                <li class="dropdown-submenu">
                                    <g:link controller="role" action="search" data-target="#">Roles</g:link>
                                    <ul class="dropdown-menu">
                                        <li><g:link controller="role" action="create">Create Role</g:link></li>
                                    </ul>
                                </li>
                            </ul>
                        </li>
                </ul>
                </sec:ifLoggedIn>
                    <ul class="nav pull-right">
                        <sec:ifLoggedIn>
                            <li class="divider-vertical"></li>
                            <li><a href="${createLink(controller:'logout',action:'index')}"><i
                                    class="icon-user"></i> Logout <sec:username/></a></li>
                        </sec:ifLoggedIn>
                        <sec:ifNotLoggedIn>
                          <li><a href="${createLink(controller:'login',action:'auth')}">Login</a></li>
                        </sec:ifNotLoggedIn>
                    </ul>

                <sec:ifLoggedIn>
                <g:form class="navbar-search pull-right" url='[controller: "search", action: "index"]'
                        id="searchableForm" name="searchableForm" method="get">

                    <div class="input-append">
                        <g:textField class="search-query " name="q" value="${params.q}" placeholder="Search"/>
                        %{--<button class="btn" type="submit">Search</button>--}%
                    </div>

                %{--<div style="clear: both; display: none;" class="hint">See <a--}%
                %{--href="http://lucene.apache.org/java/docs/queryparsersyntax.html">Lucene query syntax</a> for advanced queries--}%
                %{--</div>--}%
                </g:form>

                </sec:ifLoggedIn>
        </div>
    </div>

        <sec:ifLoggedIn>
        <ul class="breadcrumb">
        %{--<li>--}%
        <dto:breadcrumbs>${it}</dto:breadcrumbs>
        %{--</li>--}%
        </ul>

        </sec:ifLoggedIn>