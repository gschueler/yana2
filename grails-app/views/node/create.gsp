<%@ page import="com.dtolabs.Node" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'node.label', default: 'Node')}" />
		<title><g:message code="default.create.label" args="[entityName]" /></title>
		
  	<script type="text/javascript">
  	window.onload = init;
  	function init() {
  		var nodetype = $("#nodetype").val();
  		if (nodetype) {
			getAttributes();
  	  	}
  	}

  	function getFormFields(){
  		getNodeFamily("getNodeTypeParentNodes",  "unselectedParents", "children");
  		getNodeFamily("getNodeTypeChildNodes", "unselectedChildren", "parents");
		getAttributes();
  	}

  	function clearList(listItemId) {
		var sourceListItem = document.getElementById(listItemId);
		for (var i = sourceListItem.length - 1; i >= 0; i--) {
        	sourceListItem.remove(i)
		}
  	}

  	function getNodeFamily(uri, unselectedListId, selectedListId) {
  	  	clearList(unselectedListId)
  	  	clearList(selectedListId)
  		var nodetype = $("#nodetype").val();
  		if (nodetype && nodetype!=null) {
			$.ajaxSetup({contentType:"application/json"});
			$.getJSON("${request.contextPath}/node/"+uri,{id:nodetype,ajax:'true'},function(json){
				if (json) {
					var select = document.getElementById(unselectedListId);
					select.innerHTML = '';
					for(var i=0;i<json.length;i++){
						var j = json[i];
						var opt = document.createElement('option');
						opt.innerHTML=j.name + " [" + j.nodeTypeName + "]";
						opt.setAttribute('value',j.id);
						select.appendChild(opt)
					}
				}
			});
  		}
  	}

  	function selectMember(sourceListId, destListId) {
		var sourceListItem = document.getElementById(sourceListId);
		var destListItem   = document.getElementById(destListId);
	    for (var i = sourceListItem.options.length - 1; i >= 0; i--) {
	        if (sourceListItem.options[i].selected) {
	        	destListItem.add(
		          new Option(sourceListItem.options[i].text,
		        		     sourceListItem.options[i].value));
	        	sourceListItem.remove(i)
	        }
	    }
  	}

  	function selectAll() {
		var selectAllListItem = document.getElementById('parents');
	    for (var i = selectAllListItem.options.length - 1; i >= 0; i--) {
	    	selectAllListItem.options[i].selected = true;
	    }
		var selectAllListItem = document.getElementById('children');
	    for (var i = selectAllListItem.options.length - 1; i >= 0; i--) {
	    	selectAllListItem.options[i].selected = true;
	    }
  	}
  	
  	function getAttributes(){
  		var template = $("#nodetype").val();
  	  	if(template!=null){
			$.ajaxSetup({contentType:"application/json"});
			$.getJSON("${g.createLink(action: 'getNodeAttributes')}",{templateid:template,ajax:'true'},function(json){
				if(json){
					var div = document.getElementById("attributes");
					div.innerHTML = '';
					var table = document.createElement('div');
					for(var i=0;i<json.length;i++){
						var j = json[i];
						var row = document.createElement("div");
						row.id='att'+j.id+'_row'
                        $(row).addClass('control-group');
						

						if(j.required){
							row.innerHTML = '<label class="control-label" for="'+ 'att' + j.id+'">'+j.val+'*</label>';
						}else{
							row.innerHTML = '<label class="control-label" for="' + 'att' + j.id+'">'+j.val+'</label>';
						}

						var cell2 = document.createElement("div");
						cell2.id='att'+j.id+'_cell2'
                        $(cell2).addClass('controls');
						
						// input hidden - attid_require
						var require = document.createElement('input');
						require.type='hidden';
						require.name='att'+j.id+'_require';
						require.value = j.required;
						require.id='att'+j.id+'_require';
						
						// input hidden - attid_filter
						var filter = document.createElement('input');
						filter.type='hidden';
						filter.name='att'+j.id+'_filter';
						filter.value = j.filter;
						filter.id='att'+j.id+'_filter';
						
						// input text - attid
						var input = document.createElement('input');
						input.type='text';
						input.name='attributevalues.'+j.val;
						input.id='att'+j.id;
						input.size = 20;
						input.onblur =  function () {validate(this)};

                        var desc = document.createElement('span');
                        desc.innerHTML= j.datatype;
                        $(desc).addClass('help-inline');


						cell2.appendChild(require);
						cell2.appendChild(filter);
						cell2.appendChild(input);
                        cell2.appendChild(desc);
						row.appendChild(cell2);
						table.appendChild(row);
					}
					div.appendChild(table);
				}
			});
			$("#attributes").show();
  	  	}else{
  	  		$("#attributes").hide();
  	  	}
  	}

  	function validate(input){
  	  	var reset_color = '#ffffff';
  	  	var bad_color = '#ff0000';
  	  	
  		var val = input.value;
  		var filter = document.getElementById(input.id+"_filter").value;
  		var required = document.getElementById(input.id+"_require").value;
  		
  		if(!val.match(filter)){
			alert("Field does not meet required values. Please try again.");
			if(required){
				$(input.id+'_row').css("background-color","red");
  			}
  	  	}else{
  	  	  	$(input.id+'_row').css("background-color","white");
  	  	}
  	}
	</script>
	
	</head>
	<body>
		<div id="create-node" class="content scaffold-create" role="main">
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:hasErrors bean="${nodeInstance}">
			<ul class="errors" role="alert">
				<g:eachError bean="${nodeInstance}" var="error">
				<li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
				</g:eachError>
			</ul>
			</g:hasErrors>
			<g:form action="save" class="form-horizontal">
                <legend><g:message code="default.create.label" args="[entityName]"/></legend>
                <div class="control-group  ${hasErrors(bean: nodeInstance, field: 'name', 'error')} required">
					<label for="name" class="control-label"><g:message code="node.name.label" default="Name" />*</label>

                    <div class="controls">
                        <g:textField name="name" required="" value="${params?.name}"/>
                    </div>
                </div>

                <div class="control-group  ${hasErrors(bean: nodeInstance, field: 'description', 'error')} ">
                    <label class="control-label" for="description"><g:message code="node.description.label" default="Description" /></label>
                    <div class="controls">
                        <g:textField name="description" value="${params?.description}"/>
                    </div>
				</div>
				
				<div class="control-group  ${hasErrors(bean: nodeInstance, field: 'nodetype', 'error')} required">
                    <label class="control-label" for="nodetype"><g:message code="node.nodetype.label" default="Nodetype" />*</label>

                    <div class="controls">
                        <g:select id="nodetype" name="nodetype.id" from="${nodeTypeList}" optionKey="id" required="" value="${params?.nodetype}" class="many-to-one" onchange="getFormFields();"  noSelection="['null': 'Select One']"/>
                    </div>

				</div>

                <div class="control-group   ${hasErrors(bean: nodeInstance, field: 'tags', 'error')} ">
                    <label class="control-label" for="tags"><g:message code="node.tags.label" default="Tags" /></label>
                    <div class="controls">
                        <g:textField name="tags" value="${params?.tags}"/>
                    </div>
				</div>
				<div class="control-group">
					<label class="control-label" for="parents">Node Parents: </label>
                    <div class="controls">
					<select name="unselectedParents" id="unselectedParents" multiple="multiple"></select>
					<input type=button value="&gt;&gt;" onClick="selectMember('unselectedParents', 'parents')"/>
					<input type=button value="&lt;&lt;" onClick="selectMember('parents', 'unselectedParents')"/>
					<select name="parents" id="parents" value="${parents?.id}" multiple="multiple"></select>

                    </div>
				</div>
                <div class="control-group">
                    <label class="control-label" for="children">Node Children: </label>
                    <div class="controls">
                        <select name="unselectedChildren" id="unselectedChildren" multiple="multiple"></select>
                        <input type=button value="&gt;&gt;" onClick="selectMember('unselectedChildren', 'children')"/>
                        <input type=button value="&lt;&lt;" onClick="selectMember('children', 'unselectedChildren')"/>
                        <select name="children" id="children" value="${children?.id}" multiple="multiple"></select>
                    </div>
				</div>

			<div class="control-group well well-small">
                <h4>Type-specific Attributes</h4>
                <span class="help-block">Choose a Type to see Attributes.</span>
                <div id="attributes">

                </div>
			</div>
		
				<div class="form-actions">
					<g:submitButton name="create" class="btn btn-primary save" onClick="selectAll()" value="${message(code: 'default.button.create.label', default: 'Create')}" />
				</div>
			</g:form>
		</div>
		
	</body>
</html>
