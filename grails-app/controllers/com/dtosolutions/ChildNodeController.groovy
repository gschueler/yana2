package com.dtosolutions

import org.springframework.dao.DataIntegrityViolationException
import grails.plugins.springsecurity.Secured

@Secured(['ROLE_YANA_ADMIN','ROLE_YANA_ARCHITECT','ROLE_YANA_SUPERUSER'])
class ChildNodeController {

	def iconService
	
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    }

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [childNodeInstanceList: ChildNode.list(params), childNodeInstanceTotal: ChildNode.count()]
    }

    def create() {
        [childNodeInstance: new ChildNode(params)]
    }

    def save() {
		Node parent = Node.get(params.parent.toLong())
		Node child = Node.get(params.child.toLong())
		def exists = ChildNode.findByParentAndChild(parent,child)
		if(!exists){
	        def childNodeInstance = new ChildNode(params)
	        if (!childNodeInstance.save(flush: true)) {
	            render(view: "create", model: [childNodeInstance: childNodeInstance])
	            return
	        }
	
			flash.message = message(code: 'default.created.message', args: [message(code: 'childNode.label', default: 'ChildNode'), childNodeInstance.id])
	        redirect(action: "show", id: childNodeInstance.id)
		}else{
			flash.message = message("Existing relationship for that Parent and child node already exists. Please try again.")
	        render(view: "create", model: [childNodeInstance: childNodeInstance])
			return
		}
    }

    def show() {
		String path = iconService.getSmallIconPath()
        def childNodeInstance = ChildNode.get(params.id)
        if (!childNodeInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'childNode.label', default: 'ChildNode'), params.id])
            redirect(action: "list")
            return
        }

        [childNodeInstance: childNodeInstance,path:path]
    }

    def edit() {
        def childNodeInstance = ChildNode.get(params.id)
        if (!childNodeInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'childNode.label', default: 'ChildNode'), params.id])
            redirect(action: "list")
            return
        }

        [childNodeInstance: childNodeInstance]
    }

    def update() {
        def childNodeInstance = ChildNode.get(params.id)
        if (!childNodeInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'childNode.label', default: 'ChildNode'), params.id])
            redirect(action: "list")
            return
        }

        if (params.version) {
            def version = params.version.toLong()
            if (childNodeInstance.version > version) {
                childNodeInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'childNode.label', default: 'ChildNode')] as Object[],
                          "Another user has updated this ChildNode while you were editing")
                render(view: "edit", model: [childNodeInstance: childNodeInstance])
                return
            }
        }

        childNodeInstance.properties = params

        if (!childNodeInstance.save(flush: true)) {
            render(view: "edit", model: [childNodeInstance: childNodeInstance])
            return
        }

		flash.message = message(code: 'default.updated.message', args: [message(code: 'childNode.label', default: 'ChildNode'), childNodeInstance.id])
        redirect(action: "show", id: childNodeInstance.id)
    }

    def delete() {
        def childNodeInstance = ChildNode.get(params.id)
        if (!childNodeInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'childNode.label', default: 'ChildNode'), params.id])
            redirect(action: "list")
            return
        }

        try {
            childNodeInstance.delete(flush: true)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'childNode.label', default: 'ChildNode'), params.id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
			flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'childNode.label', default: 'ChildNode'), params.id])
            redirect(action: "show", id: params.id)
        }
    }
}
