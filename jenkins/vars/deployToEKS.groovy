def call(String serviceName, String imageTag) {
    def helmChartPath = "kubernetes/helm/${serviceName}"
    def imageRepo = "${env.ECR_REGISTRY}/${serviceName}"

    withCredentials([[
        $class: 'AmazonWebServicesCredentialsBinding',
        credentialsId: 'aws-keys'
    ]]) {
        sh """
            aws eks update-kubeconfig --region $AWS_DEFAULT_REGION --name $EKS_CLUSTER_NAME

            helm upgrade --install ${serviceName} ${helmChartPath} \
                --namespace default \
                --create-namespace \
                --set image.repository=${imageRepo} \
                --set image.tag=${imageTag}
        """
    }
}
