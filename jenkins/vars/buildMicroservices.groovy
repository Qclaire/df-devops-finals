def call(serviceName, serviceDir, ecrRegistry, imageTag) {
    dir(serviceDir) {
        def image = docker.build("${ecrRegistry}/${serviceName}:${imageTag}")
        image.push()
    }
}
