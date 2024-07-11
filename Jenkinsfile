pipeline {
    agent any
    
    environment {
        // Define environment variables as needed
        registryCredential = 'dockerhub-credentials' // This should match your DockerHub credentials in Jenkins
        dockerImage = 'venkats061/demo:latest' // Your DockerHub repository and image name
        kubernetesNamespace = 'default' // Adjust to your Kubernetes namespace
        kubernetesDeployFile = 'deployment.yaml' // Name of your Kubernetes deployment file
        kubernetesServiceFile = 'service.yaml' // Name of your Kubernetes service file
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout code from your Git repository
                git branch: 'main', credentialsId: 'github-venkatsatish07', url: 'https://github.com/venkatsatish07/demonstrating-our-Jenkins-job-CI-CD-Pipeline.git'
            }
        }
        
        stage('Build with Maven') {
            steps {
                // Configure Maven tool installation
                script {
                    def mvnHome = tool name: 'Maven-3.8.4', type: 'maven'
                    env.PATH = "${mvnHome}/bin:${env.PATH}"
                }
                // Run Maven build
                sh "mvn clean package"
            }
        }
        
        stage('Build Docker Image') {
            steps {
                // Build Docker image
                script {
                    docker.withRegistry('https://registry.hub.docker.com', registryCredential) {
                        def customImage = docker.build(dockerImage)
                        customImage.push()
                    }
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                // Push Docker image to DockerHub
                script {
                    docker.withRegistry('https://registry.hub.docker.com', registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                // Deploy to Kubernetes using kubectl
                script {
                    kubeconfig = credentials('kubernetes-credentials') // Assuming you have Kubernetes credentials configured in Jenkins
                    
                    sh "kubectl apply -f ${kubernetesDeployFile} -f ${kubernetesServiceFile} --kubeconfig=${kubeconfig}"
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed!'
        }
    }
}
