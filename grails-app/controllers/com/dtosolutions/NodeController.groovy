package com.dtosolutions

import org.springframework.dao.DataIntegrityViolationException
import grails.converters.JSON
import java.util.Date;

class NodeController {

	def springSecurityService
	
    static allowedMethods = [get: "POST", save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    }

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [nodeInstanceList: Node.list(params), nodeInstanceTotal: Node.count()]
    }

    def create() {
        [nodeInstance: new Node(params)]
    }

    def save() {
        def nodeInstance = new Node(params)
		
        if (!nodeInstance.save(flush: true)) {
            render(view: "create", model: [nodeInstance: nodeInstance])
            return
        }else{
			Date now = new Date()
			params.each{ key, val ->
				if (key.contains('att')) {
					TemplateAttribute att = TemplateAttribute.get(key.toInteger())
				   new TemplateValue(node:nodeInstance,templateattribute:att,value:val,dateCreated:now,dateModified:now).save(failOnError:true)
				}
			}
			flash.message = message(code: 'default.created.message', args: [message(code: 'node.label', default: 'Node'), nodeInstance.id])
	        redirect(action: "show", id: nodeInstance.id)
        }
    }

    def show() {
        def nodeInstance = Node.get(params.id)
        if (!nodeInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'node.label', default: 'Node'), params.id])
            redirect(action: "list")
            return
        }

        [nodeInstance: nodeInstance]
    }

    def edit() {
        def nodeInstance = Node.get(params.id)
        if (!nodeInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'node.label', default: 'Node'), params.id])
            redirect(action: "list")
            return
        }

        [nodeInstance: nodeInstance]
    }

    def update() {
        def nodeInstance = Node.get(params.id)
        if (!nodeInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'node.label', default: 'Node'), params.id])
            redirect(action: "list")
            return
        }

        if (params.version) {
            def version = params.version.toLong()
            if (nodeInstance.version > version) {
                nodeInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'node.label', default: 'Node')] as Object[],
                          "Another user has updated this Node while you were editing")
                render(view: "edit", model: [nodeInstance: nodeInstance])
                return
            }
        }

        nodeInstance.properties = params

        if (!nodeInstance.save(flush: true)) {
            render(view: "edit", model: [nodeInstance: nodeInstance])
            return
        }

		flash.message = message(code: 'default.updated.message', args: [message(code: 'node.label', default: 'Node'), nodeInstance.id])
        redirect(action: "show", id: nodeInstance.id)
    }

    def delete() {
        def nodeInstance = Node.get(params.id)
        if (!nodeInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'node.label', default: 'Node'), params.id])
            redirect(action: "list")
            return
        }

        try {
            nodeInstance.delete(flush: true)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'node.label', default: 'Node'), params.id])
            redirect(action: "list")
        }catch (Exception e) {
			flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'node.label', default: 'Node'), params.id])
            redirect(action: "show", id: params.id)
        }
    }
	
	def getNodeParents = {
		def response = []
		List atts = []
		if(params.id){
			atts = Node.executeQuery("select new map(N.id as id,N.name as name) from Node as N where N.node.id=${params.id}");
		}else{
			atts = Node.executeQuery("select new map(N.id as id,N.name as name) from Node as N");
		}

		atts.each(){
			response += [id:it.id,name:it.name];
		}


		render response as JSON
}
	
	def getTemplateAttributes = {
			def response = []
			if(params.templateid){
				List atts = []
				if(params.node){
					atts = TemplateAttribute.executeQuery("select new map(TV.id as tid,TV.value as templatevalue,TA.required as required,A.name as attributename,A.id as att_id,F.dataType as datatype,F.regex as filter) from TemplateAttribute as TA left join TA.values as TV left join TA.attribute as A left join A.filter as F where TA.template.id=${params.templateid} and TV.node.id=${params.node}");
				}else{
					atts = TemplateAttribute.executeQuery("select new map(TV.id as tid,TV.value as templatevalue,TA.required as required,A.name as attributename,A.id as att_id,F.dataType as datatype,F.regex as filter) from TemplateAttribute as TA left join TA.values as TV left join TA.attribute as A left join A.filter as F where TA.template.id=${params.templateid}");
				}

				atts.each(){
					response += [tid:it.tid,attid:it.att_id,required:it.required,key:it.templatevalue,val:it.attributename,datatype:it.datatype,filter:it.filter];
				}
			}

			render response as JSON
	}
	
	def getTemplates = {
			def response = []
			if(params.id){
				List temps = Template.executeQuery("select new map(T.id as id,T.templateName as name) from Template as T where T.nodetype.id=${params.id}");
				temps.each(){
					response += [id:it.id,name:it.name];
				}
			}

			render response as JSON
	}
}
