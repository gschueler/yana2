import java.awt.RenderingHints.Key;
import java.util.Date
import java.util.Set
import java.util.LinkedHashMap
import javax.xml.transform.stream.StreamSource
import javax.xml.validation.Schema
import javax.xml.validation.SchemaFactory
import javax.xml.validation.Validator
import org.xml.sax.SAXException
import groovy.util.slurpersupport.GPathResult

import com.dtolabs.*


xmlFilePath = args[0]
xsdFilePath = args[1]
endOfTestMarker = args[2]

now = new Date()

filterMap = new HashMap<String,Filter>()
filterMap.put("String", new Filter())

attributeMap = new LinkedHashMap<String,Attribute>()
nodeTypeMap = new LinkedHashMap<String,NodeType>()
nodeAttributeMap = new LinkedHashMap<NodeType,NodeAttribute>()
nodeMap = new LinkedHashMap<String,Node>()
nodeValueMap = new LinkedHashMap<String,NodeValue>()
nodeTypeRelationshipMap = new LinkedHashMap<String,NodeTypeRelationship>()
childNodeMap = new LinkedHashMap<String,ChildNode>()

def Attribute createAttribute(String name, Filter filter) {
	Attribute attribute = new Attribute()
	attribute.name = name
	attribute.filter = filter
	attribute.dateCreated = now
	attribute.dateModified = now
	attribute.description=''
	attributeMap.put(attribute.name, attribute)
	//println("attributeMap.put(${attribute.name}, ${attribute})")
	return attribute
}

def deleteAttribute(String name) {
	attributeMap.remove(name)
}

def NodeType createNodeType(String name, String description, String image) {
	NodeType nodeType = new NodeType()
	nodeType.name = name
	nodeType.description = description
	nodeType.image = image
	nodeType.dateCreated = now
	nodeType.dateModified = now
	nodeTypeMap.put(nodeType.name, nodeType)
	//println("nodeTypeMap.put(${nodeType.name}, ${nodeType})")
	return nodeType
}

def deleteNodeType(String name) {
	nodeTypeMap.remove(name)
}

def NodeAttribute createNodeAttribute(NodeType nodeType, Attribute attribute) {	
	NodeAttribute nodeAttribute = new NodeAttribute()
	nodeAttribute.nodetype = nodeType
	nodeAttribute.attribute = attribute
	nodeAttributeMap.put(nodeType.name + "::" + attribute.name,
						 nodeAttribute)
	//println("nodeAttributeMap.put(${nodeType.name}::${attribute.name}, ${nodeAtribute})")
	return nodeAttribute
}

def deleteNodeAttribute(String key) {
	nodeTypeMap.remove(key)
}

def Node createNode(String name, String description,
					String tags, NodeType nodeType) {
	Node node = new Node()
	node.name = name
	node.description = description 
	node.status = Status.IMP
	node.tags = tags
	node.nodetype = nodeType
	node.dateCreated = now
	node.dateModified = now
	nodeMap.put(node.name, node)
	//println("nodeMap.put(${node.name}, ${node})")
	return node;
}

def deleteNode(String name) {
	nodeMap.remove(name)
}

def createNodeValue(Node node, NodeAttribute nodeAttribute, String value) {
	NodeValue nodeValue = new NodeValue()
	nodeValue.node = node
	nodeValue.nodeattribute = nodeAttribute
	nodeValue.value = value
	nodeValue.dateCreated = now
	nodeValue.dateModified = now
	nodeValueMap.putAt(nodeValue.node.name
		               + "::"
					   + nodeValue.nodeattribute.attribute.name
					   + "::"
					   + nodeValue.value,
					   nodeValue)
	//println("nodeValueMap.put(${nodeValue.node.name}::${nodeValue.nodeattribute.attribute.name}::${nodeValue.value}, ${nodeValue.value})")
	return nodeValue
}

def deleteNodeValue(String key) {
	nodeMap.remove(key)
}

def createNodeRelationship(String roleName,
	                       int parentCardinality, int childCardinality,
						   NodeType parentNodeType, NodeType childNodeType) {
	NodeTypeRelationship nodeTypeRelationship = new NodeTypeRelationship()
	nodeTypeRelationship.roleName = roleName
	nodeTypeRelationship.parentCardinality = parentCardinality
	nodeTypeRelationship.childCardinality = childCardinality
	nodeTypeRelationship.child = childNodeType
	nodeTypeRelationship.parent = parentNodeType
	nodeTypeRelationshipMap.put(
	  childNodeType.name + "::" + parentNodeType.name, nodeTypeRelationship)
	//println("nodeTypeRelationshipMap.put(${childNodeType.name}::${parentNodeType.name}, ${nodeTypeRelationship})")
}

def deleteNodeRelationship(String key) {
   nodeTypeRelationshipMap.remove(key)
}

def createChildNode(String relationshipName, Node parent, Node child) {
	ChildNode childNode  = new ChildNode()
	childNode.relationshipName = relationshipName
	childNode.child = child
	childNode.parent = parent
	childNodeMap.get(child.name + "::" + parent.name, childNode)
	//println("childNodeMap.put(${child.name}::${parent.name}, ${childNode})")
	return childNode;
}

def deleteChildNode(String key) {
   childNodeMap.remove(key)
}

def parseXML() {
	File xmlFile = new File(xmlFilePath)

	// Attempt to validate the document:
	SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema")
				 .newSchema(new File(xsdFilePath))
				 .newValidator()
				 .validate(
				   new StreamSource(
					 new FileInputStream(xmlFile)))

	GPathResult xml =
	  new XmlSlurper().parse(
		new BufferedInputStream(
		  new FileInputStream(xmlFile)))
	
	// parse attributes
	xml.attributes.children().each {attributeXml ->
		createAttribute(attributeXml.@id.toString(),
						filterMap.get(attributeXml.@filter.toString()))
	}

	// parse nodetypes and nodeattributes
	xml.nodetypes.children().each {nodeTypeXml ->
		NodeType nodeType = nodeTypeMap.get(nodeTypeXml.@id.toString())
		if (!nodeType) {
			nodeType =
			  createNodeType(nodeTypeXml.@id.toString(),
                             nodeTypeXml.description.text(),
							 nodeTypeXml.image.text())
		}

		int order = 1
		nodeTypeXml.nodeAttributes.children().each {nodeAttributeXml ->
			Attribute attribute =
			  attributeMap.get(nodeAttributeXml.@attribute.toString())
			if (attribute) {
				println("${attribute.name}")
				NodeAttribute nodeAttribute =
				  nodeAttributeMap.get(nodeType.name + "::" + attribute.name)
				if (!nodeAttribute) {
					nodeAttribute =
					  createNodeAttribute(nodeType, attribute)
					order++
				}
			} else {
				//Error
			}
		}
	}
	
	// parse nodes and attributevalues
	xml.nodes.children().each {nodeXml ->
		NodeType nodeType = nodeTypeMap.get(nodeXml.@nodetype.toString())
		Node node = nodeMap.get(nodeXml.@id.toString())
		if (nodeType) {
			if (!node) {
				node = new Node()
				node = createNode(nodeXml.@id.toString(),
					              nodeXml.description.toString(),
								  node.@tags.toString(),
								  nodeType)
			} else {
				//Error
			}

			nodeXml.values.children().each {nodeValueXml ->
				def nodeAttributeNew = nodeValueXml.@nodeAttribute.toString()
				def attributeXml =
				  xml.nodetypes.nodetype.nodeAttributes.nodeAttribute.findAll {
					it.@id.text() == nodeAttributeNew
				  }
				Attribute attribute =
				  attributeMap.get(attributeXml.@attribute.toString())
				NodeAttribute nodeAttribute =
				  nodeAttributeMap.get(nodeType.name + "::" + attribute.name)
	
				NodeValue nodeValue = createNodeValue(node,
                                                      nodeAttribute,
													  nodeValueXml.toString())
			}
		} else {
			//Error
		}
	}

	// parse nodetype parent/child
	xml.nodetyperelationships.children().each {nodeTypeRelationshipsXml ->
		// get dependencies
		NodeType parentNodeType = nodeTypeMap.get(nodeTypeRelationshipsXml.@parent.toString())
		NodeType childNodeType  = nodeTypeMap.get(nodeTypeRelationshipsXml.@child.toString())

		NodeTypeRelationship nodeTypeRelationship =
		  nodeTypeRelationshipMap.get(childNodeType.name + "::" + parentNodeType.name)
		if (!nodeTypeRelationship) {
			nodeTypeRelationship =
			  createNodeRelationship(nodeTypeRelationshipsXml.@rolename.toString(), 
									 (nodeTypeRelationshipsXml.@parentCardinality.toString()
									  ? nodeTypeRelationshipsXml.@parentCardinality.toInteger()
									  : '999999999'.toInteger()),
									 (nodeTypeRelationshipsXml.@childCardinality.toString()
									  ? nodeTypeRelationshipsXml.@childCardinality.toInteger()
									  : '999999999'.toInteger()),
									 parentNodeType, childNodeType)
		} else {
			//Error!
		}
	}
	
	// parse node parent/child
	xml.noderelationships.children().each {nodeRelationshipsXml ->
		// get dependencies
		Node parent = nodeMap.get(nodeRelationshipsXml.@parent.toString())
		Node child =  nodeMap.get(nodeRelationshipsXml.@child.toString())
		childNodeTypes = new ArrayList<Node>()
		parentNodeTypes = new ArrayList<Node>()
		nodeMap.each() {key, node ->
			if (child.nodetype.name == node.nodetype.name) {
				childNodeTypes.add(node)
			}
			if (parent.nodetype.name == node.nodetype.name) {
				parentNodeTypes.add(node)
			}
		}
		
		ChildNode childNode =
		  childNodeMap.get(child.name + "::" + parent.name)
		NodeTypeRelationship nodeTypeRelationship =
		  nodeTypeRelationshipMap.get(child.nodetype.name + "::" + parent.nodetype.name)
		if (!childNode && nodeTypeRelationship
			&& (!nodeTypeRelationship.childCardinality
				|| (nodeRelationshipsXml.childCardinality == 0)
				|| (childNodeTypes.size() + 1 <= nodeTypeRelationship.childCardinality))
			&& (!nodeTypeRelationship.parentCardinality
				|| (nodeRelationshipsXml.parentCardinality == 0)
				|| (parentNodeTypes.size() + 1 <= nodeTypeRelationship.parentCardinality))) {
			childNode = createChildNode(nodeRelationshipsXml.@relationshipname.toString(),
                                        parent, child)
		} else {
			//Error
		}
	}
}


def emitRerunImportXmlTest() {
	println("TEST:ImportXmlTest")
	println("RERUN:yana:import -f ${xmlFilePath}")
	println(endOfTestMarker)
}

def emitRerunNodesTest() {
	println("TEST:NodesTest")
	println("RERUN:yana:nodes -l")
	int i = 0
	nodeMap.each() {key, value ->
		println(value.nodetype.name
				+ ":" + value.name
				+ ":" + ++i)
	}
	println(endOfTestMarker)
}

def emitRerunNodesByAllTypeTest() {
	println("TEST:NodesByAllTypeTest")
	println("RERUN:yana:nodes -t")
	int i = 0
	nodeMap.each() {key, value ->
		println(value.nodetype.name
				+ ":" + value.name
				+ ":" + ++i)
	}
	println(endOfTestMarker)
}

def emitRerunNodesByTypeTest() {		
	nodeTypeMap.each() {nodeTypeMapKey, nodeTypeMapValue ->
		println("TEST:NodesByTypeTest")
		println("RERUN:yana:nodes -t " + nodeTypeMapKey)
		int j = 0
		nodeMap.each() {nodeMapKey, nodeMapValue ->
			++j
			if (nodeTypeMapKey == nodeMapValue.nodetype.name) {
				println(nodeTypeMapKey
						+ ":" + nodeMapValue.name
						+ ":" + j)
			}
		}
		println(endOfTestMarker)
	}
}

def emitRerunNodeByIdTest() {
	int i = 0
	nodeMap.each() {nodeMapKey, nodeMapValue ->
		println("TEST:NodeByIdTest")
		println("RERUN:yana:node -i " + ++i)
		println("name:" + nodeMapValue.name)
		println("type:" + nodeMapValue.nodetype.name)
		//println("description:" + nodeMapValue.description)
		//println("status:" + ":" + value.status)
		//println("tags:" + ":" + value.tags)
		nodeValueMap.each() {nodeValueMapKey, nodeValueMapValue ->
			if (nodeMapValue.name == nodeValueMapValue.node.name) {
				println(nodeValueMapValue.nodeattribute.attribute.name
					    + ":" + nodeValueMapValue.value)
			}
		}
		println(endOfTestMarker)
	}
}

def emitRerunTypesTest() {
	println("TEST:TypesTest")
	println("RERUN:yana:types -l")
	int i = 0
	nodeTypeMap.each() {key, value ->
		println(value.name
				+ ":" + value.description
				+ ":" + ++i)
	}
	println(endOfTestMarker)
}

def emitRerunTypesByTypeTest() {
	int i = 0
	nodeTypeMap.each() {key, value ->
		println("TEST:TypesByTypeTest")
		println("RERUN:yana:types -t " + value.name)
		println(value.name
				+ ":" + value.description
				+ ":" + ++i)
		println(endOfTestMarker)
	}
}

def emitRerunTypeByTypeTest() {
	int i = 0
	nodeTypeMap.each() {nodeTypeMapKey, nodeTypeMapValue ->
		println("TEST:TypeByTypeTest")
		println("RERUN:yana:type -t " + nodeTypeMapValue.name)
		println("type:" + nodeTypeMapValue.name)
		println("description:" + nodeTypeMapValue.description)
		println("id:" + ++i)
		delim = ""
		print("attributes:")
		nodeAttributeMap.each() {nodeAttributeMapKey, nodeAttributeMapValue ->
			if (nodeTypeMapValue.name == nodeAttributeMapValue.nodetype.name) {
				print(delim + nodeAttributeMapValue.attribute.name)
				delim = ","
			}
		}
		println();
		delim = ""
		print("relationships:")
		nodeTypeRelationshipMap.each() {nodeTypeRelationshipMapKey, nodeTypeRelationshipMapValue ->
			if ((nodeTypeMapValue.name == nodeTypeRelationshipMapValue.child.name)
				|| (nodeTypeMapValue.name == nodeTypeRelationshipMapValue.parent.name)) {
				print(delim + nodeTypeRelationshipMapValue.roleName)
				delim = ","
			}
		}
		println();
		println(endOfTestMarker)
	}
}

parseXML()

emitRerunImportXmlTest()

emitRerunNodesTest()
emitRerunNodesByAllTypeTest();
emitRerunNodesByTypeTest()

emitRerunNodeByIdTest()

emitRerunTypesTest()
emitRerunTypesByTypeTest()

emitRerunTypeByTypeTest()

//yana:child-node -a list
//emitRerunChildNodeTest()