package com.dtosolutions

import org.junit.*
import grails.test.mixin.*

@TestFor(NodeController)
@Mock(Node)
class NodeControllerTests {


    def populateValidParams(params) {
      assert params != null
      // TODO: Populate valid properties like...
	  Date now = new Date()
	  mockDomain(NodeType, [new NodeType(id:1,version:1,name:'Server',dateCreated:now)])
	  NodeType server = NodeType.get(1)
	  
	  params["id"] = 1
	  params["version"] = 1
      params["name"] = 'node_name'
	  params["description"] = "some description"
	  params["status"] = Status.IMP
	  params["tags"] = "this,is,a,test"
	  params["nodetype"] = server
	  params["dateCreated"] = new Date()
	  params["dateModified"] = new Date()

    }

    void testIndex() {
        controller.index()
        assert "/node/list" == response.redirectedUrl
    }

	/*
	 * need to fix for includded service call
    void testList() {

        def model = controller.list()

        assert model.nodeInstanceList.size() == 0
        assert model.nodeInstanceTotal == 0
    }
    */

    void testCreate() {
       def model = controller.create()
    }

	/* fix
    void testSave() {
		populateValidParams(params)
        //controller.save()
		
		def node = new Node(params)
		if(node.save()){
			assert node.save(flush:true) != null
			
			controller.update()
			params.id = node.id
			assert response.redirectedUrl == "/node/show/${node.id}"
			assert controller.flash.message != null
			assert Node.count() == 1
		}else{
			assert view == '/node/create'
		}

    }
    */

    void testShow() {
        //controller.show()

        //assert flash.message != null
        //assert response.redirectedUrl == '/node/list'


        populateValidParams(params)
        def node = new Node(params)

        assert node.save() != null

        params.id = node.id

        //def model = controller.show()

        //assert model.nodeInstance == node
    }

    void testEdit() {
		populateValidParams(params)
		params.id = 1
        controller.edit()

        assert flash.message != null
        assert response.redirectedUrl == '/node/list'


        populateValidParams(params)
        def node = new Node(params)

        assert node.save() != null

        params.id = node.id

        //def model = controller.edit()

        //assert model.nodeInstance == node
    }

	/* fix
    void testUpdate() {
        controller.update()


        populateValidParams(params)
        def node = new Node(params)

		if(node.save()){
			
			assert node.save(flush:true) != null
			
			//FIX
			controller.update()
			params.id = node.id
			assert response.redirectedUrl == "/node/show/${node.id}"
			assert flash.message != null
		}else{
			// test invalid parameters in update
			//TODO: add invalid values to params object
			assert view == "/node/edit"
			
		}

        controller.update()
        node.clearErrors()
        populateValidParams(params)
		

        //test outdated version number
        response.reset()
        node.clearErrors()

        populateValidParams(params)
        params.id = node.id
        params.version = -1
        controller.update()

        assert view == "/node/edit"
        assert model.nodeInstance != null
        assert model.nodeInstance.errors.getFieldError('version')
        assert flash.message != null
    }
    */

    void testDelete() {
        controller.delete()
        assert flash.message != null
        assert response.redirectedUrl == '/node/list'

        response.reset()

        populateValidParams(params)
        def node = new Node(params)

        assert node.save() != null
        assert Node.count() == 1

        params.id = node.id

        //controller.delete()

        //assert Node.count() == 0
        //assert Node.get(node.id) == null
        //assert response.redirectedUrl == '/node/list'
    }
}
