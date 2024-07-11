pipeline {
    agent any
    
    environment {
        registry = "venkats061/demo"
        dockerImage = ''
        // Define credentials for GitHub and DockerHub
        githubCredential = 'github-venkatsatish07'
        dockerHubCredential = 'dockerhub-venkats061'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
                          doGenerateSubmoduleConfigurations: false,
                          extensions: [],
                          submoduleCfg: [],
                          userRemoteConfigs: [[credentialsId: 'github-venkatsatish07',
                                               url: 'https://github.com/venkatsatish07/demonstrating-our-Jenkins-job-CI-CD-Pipeline.git']]])
            }
        }
        
        stage('Build') {
            steps {
                script {
                    def mvnHome = tool 'Maven 3.8.4'
                    sh "${mvnHome}/bin/mvn clean package -DskipTests"
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build registry + ":latest"
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', dockerHubCredential) {
                        dockerImage.push()
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Update deployment.yaml with new image tag
                    sh "sed -i 's#image: venkats061/demo:latest#image: ${registry}:latest#' deployment.yaml"
                    // Apply deployment to Kubernetes
                    sh "kubectl apply -f deployment.yaml"
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline successfully completed!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
