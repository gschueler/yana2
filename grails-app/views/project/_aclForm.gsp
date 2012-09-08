<%@ page import="com.dtolabs.yana2.springacl.YanaPermission; com.dtolabs.Project" %>

<div >
    <div>
        <button class="btn grantButton" data-toggle="modal" data-target="#permissionForm">Add Permission
            <i class="icon-plus"></i>
        </button>
    </div>
    <g:form action="saveProjectPermission" id="saveProjectPermission" class="form-horizontal saveProjectPermission">
        <g:hiddenField name="name" value="${project.name}"/>
    <div class="modal hide " id="permissionForm" tabindex="-1" role="dialog"
                                 aria-labelledby="myModalLabel" aria-hidden="true">
    %{--<div class="permissionForm well-small" style="display: none;">--}%


        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal"
                    aria-hidden="true">&times;</button>

            <h3 id="myModalLabel">Add a new Permission</h3>
        </div>

        <div class="modal-body">

            <div class="control-group">
                <label class="control-label" for="permissionGrant">
                    Grant/Deny
                </label>

                <div class="controls">
                    <g:select name="permissionGrant" from="['grant', 'deny']" id="permissionGrant"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="permission">
                    Permission
                </label>

                <div class="controls">
                    <g:select name="permission" id="permission" from="${YanaPermission.byName.keySet()}"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="recipient">
                    To User/Role
                </label>

                <div class="controls">
                    <g:textField id="recipient" name="recipient" value="" placeholder="Username or ROLE_*"
                                 data-provide="typeahead"
                                 autocomplete='off'/>
                </div>
            </div>

        </div>

        <div class="modal-footer">

            <a href="#" data-dismiss="modal" class="btn" aria-hidden="true">Cancel</a>
            <g:submitButton name="Add Permission" class="btn btn-success"/>
        </div>

    </div>
        </g:form>
</div>

<div class="list">
    <table class="table table-striped table-hover">
        <thead>
        <tr>
            <td>${g.message(code: 'recipient.type.label', default: 'Type')}</td>
            <td>${g.message(code: 'name.label', default: 'Name')}</td>
            <td colspan="2">${g.message(code: 'permission.label', default: 'Permission')}</td>
            <td>${g.message(code: 'action.label', default: 'Action')}</td>
        </tr>
        </thead>

        <tbody>

        <g:each in="${acls}" var="aclEntry" status="i">
            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
            <g:set var="recipient" value="${aclEntry.role ?: aclEntry.username}"/>
                <td>
                    <span class="recipientType">${g.message(code:'recipient.type.'+(aclEntry.role ? 'role' : 'user')+'.label')}</span>
                </td>
                <td>
                    <span class="recipient">${recipient.encodeAsHTML()}</span>
                </td>
                <td>
                    <span class="granted">${aclEntry.granted ? 'ALLOW' : 'DENY'}</span>
                </td>
                <td>
                    <span class="permission">${g.message(code: 'permission.'+ aclEntry.permission+'.label', default: aclEntry.permission)}</span>
                </td>
                <td>
                    <button data-toggle="modal" data-target="#deleteForm${i}"
                            class="btn-danger btn btn-small"
                            ><g:message code="default.button.delete.label"/></button>

                    <g:form controller="project" action="deleteProjectPermission" class="form-horizontal">
                        <g:hiddenField name="name" value="${project.name}"/>

                        <div class="modal hide " id="deleteForm${i}" tabindex="-1" role="dialog"
                             aria-labelledby="deleteFormLabel${i}" aria-hidden="true">
                            %{--<div class="permissionForm well-small" style="display: none;">--}%


                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal"
                                        aria-hidden="true">&times;</button>

                                <h3 id="deleteFormLabel${i}">Really delete this Permission?</h3>
                            </div>

                            <div class="modal-body">
                                <p>
                                    <strong>${aclEntry.granted ? 'ALLOW' : 'DENY'}</strong>
                                    <em>${g.message(code: 'permission.' + aclEntry.permission + '.label', default: aclEntry.permission)}</em>
                                </p>

                                <p>for</p>

                                <p>
                                    <span class="muted">${g.message(code: 'recipient.type.' + (aclEntry.role ? 'role' : 'user') + '.label')}</span>
                                    <span class="recipient">"${recipient.encodeAsHTML()}"</span>
                                </p>
                            </div>

                            <div class="modal-footer">

                                <a href="#" data-dismiss="modal" class="btn" aria-hidden="true">No</a>
                                <g:submitButton
                                        class="btn-danger btn"
                                        name="Yes, ${g.message(code: 'default.button.delete.label')} it"
                                        />
                            </div>

                        </div>
                        <g:hiddenField name="name" value="${project.name}"/>
                        <g:hiddenField name="recipient" value="${recipient}"/>
                        <g:hiddenField name="permission" value="${aclEntry.permission}"/>
                        <g:hiddenField name="permissionGrant" value="${aclEntry.granted ? 'grant' : 'deny'}"/>
                    </g:form>

                </td>
            </tr>
            </g:each>
        </tbody>
    </table>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        //bootstrap style auto complete via ajax
        $('#recipient').typeahead({
                                      minLength:3,
                                      items:10,
                                      source:function (query, callback) {
                                          $.ajax("${createLink(action: 'ajaxUserRoleSearch',controller: 'user')}", {
                                              data:{term:query, style:'bootstrap'},
                                              dataType:'json',
                                              success:callback
                                          });
                                      }
                                  });
        $('form.saveProjectPermission').submit(function (evt) {
            if($('#recipient').val()==''){

                $("#recipient").effect('highlight', {}, 1000);
                evt.preventDefault();
                return false;
            }
            return true;
        });
    });
</script>