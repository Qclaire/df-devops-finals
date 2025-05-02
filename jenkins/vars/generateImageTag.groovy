def call() {
    def date = new Date().format('yyyy.MM.dd')
    return "${date}.v${env.BUILD_NUMBER}"
}
