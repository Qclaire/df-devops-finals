pipeline {
    agent any

    environment {
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        AWS_DEFAULT_REGION = credentials('AWS_REGION')
        ECR_REGISTRY = credentials('ECR_REGISTRY')
    }

    stages {
        stage('Login to ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {
                    sh '''
                        aws ecr get-login-password --region $AWS_DEFAULT_REGION | \
                          docker login --username AWS --password-stdin $ECR_REGISTRY
                    '''
                }
            }
        }

        stage('Build & Push Go Service') {
            steps {
                dir('microservices/go-service') {
                    script {
                        def image = docker.build("${ECR_REGISTRY}/go-service:${IMAGE_TAG}")
                        image.push()
                    }
                }
            }
        }

        stage('Build & Push Python Service') {
            steps {
                dir('microservices/python-service') {
                    script {
                        def image = docker.build("${ECR_REGISTRY}/python-service:${IMAGE_TAG}")
                        image.push()
                    }
                }
            }
        }

        stage('Build & Push Rail Service') {
            steps {
                dir('microservices/rail-service') {
                    script {
                        def image = docker.build("${ECR_REGISTRY}/rail-service:${IMAGE_TAG}")
                        image.push()
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
