package com.dtolabs

import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.access.prepost.PostFilter

class NodeService {
    def projectService
    def aclService
    def aclUtilService
    def springSecurityService
    /**
     * Create a node, requires 'operator' or 'admin' permission.
     * @param project
     * @param nodeType
     * @param name
     * @param description
     * @param tags
     * @param parentIds
     * @param childIds
     * @param nodeValues
     * @return
     */
	Node createNode(Project project,
						NodeType nodeType,
						String name,
						String description,
						String tags,
						List<Long> parentIds,
						List<Long> childIds,
						List<NodeValue> nodeValues) {
        projectService.authorizedOperatorPermission(nodeType.project)
		return commitNode(false, project, new Node(),
			              nodeType, name, description, tags,
			  			  getParentNodesFromIDs(parentIds, nodeType),
						  getChildNodesFromIDs(childIds, nodeType),
						  nodeValues)

	}

	void updateNode(Project project,
						Node nodeInstance,
						String name,
						String description,
						String tags,
						List<Long> parentIds,
						List<Long> childIds,
						List<NodeValue> nodeValues) {
        projectService.authorizedOperatorPermission(nodeInstance.project)
		commitNode(true, project, nodeInstance,
				   nodeInstance.nodetype, name, description, tags,
	  			   getParentNodesFromIDs(parentIds, nodeInstance.nodetype),
				   getChildNodesFromIDs(childIds, nodeInstance.nodetype),
				   nodeValues)
	}

    void deleteNode(Node nodeInstance) {
        projectService.authorizedOperatorPermission(nodeInstance.project)
		Node.withTransaction{ status ->
			try {
				deleteParentsAndChildren(nodeInstance)

				nodeInstance.delete(flush: true)
			} catch (Exception e) {
				status.setRollbackOnly()
				throw e
			}
		}
	}

    private Node readNode(Node node)
    {
        projectService.authorizedReadPermission(node.project)
        return node
    }
    Node readNode(id)
    {
        def node = Node.get(id)
        if(!node){
            return null
        }
        return readNode(node)
    }

	Node cloneNode(Node nodeInstance) {
        projectService.authorizedOperatorPermission(nodeInstance.project)
		List<NodeValue> nodeValues = []
		nodeInstance.nodeValues.each() {NodeValue nodeValue ->
			def nodeValueClone = new NodeValue()
			nodeValueClone.nodeattribute = nodeValue.nodeattribute
			nodeValueClone.value = nodeValue.value
			nodeValues += nodeValueClone
		}
		
		return commitNode(false, nodeInstance.project, new Node(),
						  nodeInstance.nodetype,
						  nodeInstance.name  + "_clone",
						  nodeInstance.description,
						  nodeInstance.tags,
						  [], [],
						  nodeValues)
	}

	private Node commitNode(boolean doUpdate,
							Project project,
							Node nodeInstance,
							NodeType nodeType,
							String name,
							String description,
							String tags,
							List<Node> parentList,
							List<Node> childList,
							List<NodeValue> nodeValues) {
		nodeInstance.name = name
		nodeInstance.description = description
		nodeInstance.tags = tags
		if (!doUpdate) {
			nodeInstance.project = project
			nodeInstance.nodetype = nodeType;
		}

		Node.withTransaction() {status ->
			try {
				if (!nodeInstance.save(flush: true)) {
					throw new Exception()
				}

				if (doUpdate) {
					deleteParentsAndChildren(nodeInstance)
				}

				// Next, assign all selected parent nodes of this node.
				parentList.each {parent ->
					addChildNode(parent, nodeInstance)
				}

				// Next, assign all selected child nodes of this node.
				childList.each {child ->
					addChildNode(nodeInstance, child)
				}

				// Next, assign all the NodeValue objects for this node.
				nodeValues.each {nodeValue ->
					if (!doUpdate) {
						nodeValue.node = nodeInstance
					}
					nodeValue.save().save(failOnError:true)
				}
			} catch (Exception e) {
				status.setRollbackOnly()
				throw e;
			}
		}
		
		return nodeInstance
	}

    private deleteParentsAndChildren(Node nodeInstance) {
		["child", "parent"].each { kind ->
			ChildNode.createCriteria().list {
				eq(kind, nodeInstance)
			}.each { childNode ->
				childNode.delete()
			}
		}
	}
	
	private deleteNodeValues(Node nodeInstance) {
		nodeInstance.nodeValues.each { nodeValue ->
			nodeValue.delete()	
		}
	}

	private List<Node> getSelectedMembers(List<Node> selectedNodes,
										  List<Node> nodeCandidatesList) {
		List<Node> selectedMembers = []
		if (selectedNodes && nodeCandidatesList) {
			selectedNodes.each {selectedNode ->
				if (nodeCandidatesList.contains(selectedNode)) {
					selectedMembers += selectedNode
				}
			}
		}
		return selectedMembers
	}

	private List<Node> getParentNodesFromIDs(List<Long> nodeIDs, NodeType nodeType) {
		List<Node> nodes = []
		if (nodeIDs && (nodeIDs.size() != 0)) {
		    nodes = getSelectedMembers(Node.findAll("from Node as N where N.id IN (:ids)",
													[ids:nodeIDs]),
						  			   getNodeParentCandidates(nodeType))
		}
		return nodes
	}
	
	private List<Node> getChildNodesFromIDs(List<Long> nodeIDs, NodeType nodeType) {
		List<Node> nodes = []
		if (nodeIDs && (nodeIDs.size() != 0)) {
			nodes = getSelectedMembers(Node.findAll("from Node as N where N.id IN (:ids)",
													[ids:nodeIDs]),
									   getNodeChildrenCandidates(nodeType))
		}
		return nodes
	}

	private List<Node> getNodeParentCandidates(NodeType nodeType) {
		def parents = []
		nodeType.children.each {nodeTypeRelationship ->
			nodeTypeRelationship.parent.nodes.each {node ->
				parents += node
			}
		}
		return parents
	}

	private List<Node> getNodeChildrenCandidates(NodeType nodeType) {
		def children = []
		nodeType.parents.each {nodeTypeRelationship ->
			nodeTypeRelationship.child.nodes.each {node ->
				children += node
			}
		}
		return children
	}
	
	private boolean addChildNode(Node parent, Node child) {
		ChildNode childNode = ChildNode.findByParentAndChild(parent, child)
		if (!childNode) {
			childNode = new ChildNode()
			childNode.parent = parent
			childNode.child = child
			childNode.save(flush: true)
			return true
		} else {
			return false
		}
	}

}
