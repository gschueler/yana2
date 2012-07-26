package com.dtolabs

class ProjectService {
    static transactional=true

    def servletContext

    def listProjects() {
        return Project.list()
    }

    def userSelectProject(session, Project p){
        session.project = p.name
    }

    def createProject(String name, String description){
        def project = new Project(name: name, description: description)
        if(!project.save()){
            log.error("Unable to create project: "+project)
        }else{
            Properties defaultFilters = new Properties()
            if(null!=servletContext){
                def instream = servletContext.getResourceAsStream("/properties/default-filters.properties")
                if (instream) {
                    defaultFilters.load(instream)
                }
                defaultFilters.each {String k, String v ->
                    if (!Filter.findByProjectAndDataType(proj, k)) {
                        Filter test = new Filter(dataType: k, regex: v)
                        test.project = proj
                        test.save(failOnError: true, flush: true)
                    }
                }
            }
        }
        return project
    }
}
