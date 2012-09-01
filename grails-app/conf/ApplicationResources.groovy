modules = {
    application {
        resource url:'js/application.js'
    }
    'custom-bootstrap' {
        dependsOn 'bootstrap'
        resource url: [dir: 'less', file: 'custom-bootstrap.less'], attrs: [rel: "stylesheet/less", type: 'css']
    }

}