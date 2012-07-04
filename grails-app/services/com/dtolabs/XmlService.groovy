package com.dtolabs

import groovy.xml.MarkupBuilder
import org.custommonkey.xmlunit.*

class XmlService {
	
	static transactional = false
	static scope = "prototype"
	
	String formatNodes(ArrayList nodes){
		def writer = new StringWriter()
		def xml = new MarkupBuilder(writer)
			
		xml.nodes() {
			nodes.each(){ val1 ->
				def attributequery = "select new map(TV.value as value,A.name as attribute,TA.required as required,A.id as id) from NodeValue as TV left join TV.node as N left join TV.nodeattribute as TA left join TA.attribute as A where N.id=${val1.id.toLong()} order by A.name desc"
				def values = NodeValue.executeQuery(attributequery);
				
				node(id:val1.id,name:val1.name,nodetypeId:val1.nodetype.id,type:val1.nodetype.name,tags:val1.tags){
					description(val1.description)
					attributes(){
						values.each{ val2 ->
							attribute(id:val2.id,name:val2.attribute,value:val2.value,required:val2.required)
						}
					}

					parents(){
						def rents = ChildNode.findAllByChild(Node.get(val1.id.toLong()));
						rents.each{ parent ->
							node(id:parent.parent.id,name:parent.parent.name,nodetypeId:parent.parent.nodetype.id,type:parent.parent.nodetype.name,tags:parent.parent.tags,relationshipName:parent.relationshipName,rolename:NodeTypeRelationship.findByParentAndChild(parent.parent.nodetype,parent.child.nodetype).roleName)
						}
					}

					children(){
						def kinder = ChildNode.findAllByParent(Node.get(val1.id.toLong()));
						kinder.each{ child ->
							node(id:child.child.id,name:child.child.name,nodetypeId:child.child.nodetype.id,type:child.child.nodetype.name,tags:child.child.tags,relationshipName:child.relationshipName,rolename:NodeTypeRelationship.findByParentAndChild(child.parent.nodetype,child.child.nodetype).roleName)
						}
					}
				}
			}
		}
		return writer.toString()
	}
	
	String formatChildNodes(ArrayList cnodes){
		def writer = new StringWriter()
		def xml = new MarkupBuilder(writer)
			
		xml.childNodes() {
			cnodes.each(){ val1 ->
				childNode(id:val1.id,parentNodeId:val1.parent.id,parentName:val1.parent.name,parentNodeType:val1.parent.nodetype.name,childNodeId:val1.child.id,childName:val1.child.name,childNodeType:val1.child.nodetype.name,relationshipName:val1.relationshipName)
			}
		}
		return writer.toString()
	}
	
	String formatNodeValues(ArrayList tvals){
		def writer = new StringWriter()
		def xml = new MarkupBuilder(writer)
			
		xml.nodeValues() {
			tvals.each(){ val1 ->
				nodeValue(id:val1.id,nodeId:val1.node.id,nodeAttributeId:val1.nodeattribute.id,value:val1.value)
			}
		}
		return writer.toString()
	}
	
	String formatNodeAttributes(ArrayList tatts){
		def writer = new StringWriter()
		def xml = new MarkupBuilder(writer)
			
		xml.nodeAttributes() {
			tatts.each(){ val1 ->
				nodeAttribute(id:val1.id,attributeId:val1.attribute.id,nodetypeId:val1.nodetype.id,required:val1.required)
			}
		}
		return writer.toString()
	}
	
	String formatFilters(ArrayList filters){
		def writer = new StringWriter()
		def xml = new MarkupBuilder(writer)
			
		xml.filters() {
			filters.each(){ val1 ->
				filter(id:val1.id,dataType:val1.dataType,regex:val1.regex)
			}
		}
		return writer.toString()
	}
	
	String formatAttributes(ArrayList attributes){
		def writer = new StringWriter()
		def xml = new MarkupBuilder(writer)
			
		xml.attributes() {
			attributes.each(){ val1 ->
				attribute(id:val1.id,name:val1.name,description:val1.description,filterId:val1.filter.id)
			}
		}
		return writer.toString()
	}
	
	String formatNodeTypes(ArrayList nodetypes){
		def writer = new StringWriter()
		def xml = new MarkupBuilder(writer)
			
		xml.nodetypes() {
			nodetypes.each(){ val1 ->
				def nodecount = Node.findAllByNodetype(val1).size()
				def tatts = NodeAttribute.findAllByNodetype(NodeType.get(val1.id.toLong()))
				
				def criteria = NodeTypeRelationship.createCriteria()
				def parents = criteria.list{
					eq("child", NodeType.get(val1.id?.toLong()))
				}
				
				def criteria2 = NodeTypeRelationship.createCriteria()
				def children = criteria2.list{
					eq ("parent", NodeType.get(val1.id?.toLong()))
				}
				
				nodetype(id:val1.id,name:val1.name,description:val1.description,image:val1.image,nodeCount:nodecount){
					nodeAttributes() {
						tatts.each(){ val2 ->
							nodeAttribute(id:val2.id,attributeName:val2.attribute.name,attributeId:val2.attribute.id,nodetypeId:val2.nodetype.id,required:val2.required)
						}
					}
					nodetypeRelationships() {
						parents.each(){ val3 ->
							nodetypeRelationship(id:val3.id,parentNodeId:val3.parent.id,parentName:val3.parent.name,childNodeId:val3.child.id,childName:val3.child.name,roleName:val3.roleName)
						}
						children.each(){ val4 ->
							nodetypeRelationship(id:val4.id,parentNodeId:val4.parent.id,parentName:val4.parent.name,childNodeId:val4.child.id,childName:val4.child.name,roleName:val4.roleName)
						}
					}
				}
			}
		}
		return writer.toString()
	}
	
	String formatHooks(ArrayList hooks){
		def writer = new StringWriter()
		def xml = new MarkupBuilder(writer)
			
		xml.hooks() {
			hooks.each(){ val1 ->
				hook(id:val1.id,name:val1.name,url:val1.url,format:val1.format,service:val1.service,fails:val1.attempts){
					user(val1.user.username)
				}
			}
		}
		return writer.toString()
	}
}
