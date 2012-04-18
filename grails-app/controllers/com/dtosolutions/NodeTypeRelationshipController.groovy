package com.dtosolutions

import org.springframework.dao.DataIntegrityViolationException

class NodeTypeRelationshipController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    }

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [nodeTypeRelationshipInstanceList: NodeTypeRelationship.list(params), nodeTypeRelationshipInstanceTotal: NodeTypeRelationship.count()]
    }

    def create() {
        [nodeTypeRelationshipInstance: new NodeTypeRelationship(params)]
    }

    def save() {
        def nodeTypeRelationshipInstance = new NodeTypeRelationship(params)
        if (!nodeTypeRelationshipInstance.save(flush: true)) {
            render(view: "create", model: [nodeTypeRelationshipInstance: nodeTypeRelationshipInstance])
            return
        }

		flash.message = message(code: 'default.created.message', args: [message(code: 'nodeTypeRelationship.label', default: 'NodeTypeRelationship'), nodeTypeRelationshipInstance.id])
        redirect(action: "show", id: nodeTypeRelationshipInstance.id)
    }

    def show() {
        def nodeTypeRelationshipInstance = NodeTypeRelationship.get(params.id)
        if (!nodeTypeRelationshipInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'nodeTypeRelationship.label', default: 'NodeTypeRelationship'), params.id])
            redirect(action: "list")
            return
        }

        [nodeTypeRelationshipInstance: nodeTypeRelationshipInstance]
    }

    def edit() {
        def nodeTypeRelationshipInstance = NodeTypeRelationship.get(params.id)
        if (!nodeTypeRelationshipInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'nodeTypeRelationship.label', default: 'NodeTypeRelationship'), params.id])
            redirect(action: "list")
            return
        }

        [nodeTypeRelationshipInstance: nodeTypeRelationshipInstance]
    }

    def update() {
        def nodeTypeRelationshipInstance = NodeTypeRelationship.get(params.id)
        if (!nodeTypeRelationshipInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'nodeTypeRelationship.label', default: 'NodeTypeRelationship'), params.id])
            redirect(action: "list")
            return
        }

        if (params.version) {
            def version = params.version.toLong()
            if (nodeTypeRelationshipInstance.version > version) {
                nodeTypeRelationshipInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'nodeTypeRelationship.label', default: 'NodeTypeRelationship')] as Object[],
                          "Another user has updated this NodeTypeRelationship while you were editing")
                render(view: "edit", model: [nodeTypeRelationshipInstance: nodeTypeRelationshipInstance])
                return
            }
        }

        nodeTypeRelationshipInstance.properties = params

        if (!nodeTypeRelationshipInstance.save(flush: true)) {
            render(view: "edit", model: [nodeTypeRelationshipInstance: nodeTypeRelationshipInstance])
            return
        }

		flash.message = message(code: 'default.updated.message', args: [message(code: 'nodeTypeRelationship.label', default: 'NodeTypeRelationship'), nodeTypeRelationshipInstance.id])
        redirect(action: "show", id: nodeTypeRelationshipInstance.id)
    }

    def delete() {
        def nodeTypeRelationshipInstance = NodeTypeRelationship.get(params.id)
        if (!nodeTypeRelationshipInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'nodeTypeRelationship.label', default: 'NodeTypeRelationship'), params.id])
            redirect(action: "list")
            return
        }

        try {
            nodeTypeRelationshipInstance.delete(flush: true)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'nodeTypeRelationship.label', default: 'NodeTypeRelationship'), params.id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
			flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'nodeTypeRelationship.label', default: 'NodeTypeRelationship'), params.id])
            redirect(action: "show", id: params.id)
        }
    }
}