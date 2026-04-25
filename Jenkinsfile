pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "angela005/securescan"
        DOCKER_TAG   = "latest"
    }
    stages {
        stage('Checkout') {
            steps {
                echo 'Code checked out from GitHub'
            }
        }
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                bat 'docker build -t %DOCKER_IMAGE%:%DOCKER_TAG% .'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing to Docker Hub...'
                bat 'docker push %DOCKER_IMAGE%:%DOCKER_TAG%'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes...'
                bat 'kubectl apply -f k8s/deployment.yaml'
                bat 'kubectl apply -f k8s/service.yaml'
            }
        }
    }
    post {
        success { echo 'SUCCESS - SecureScan deployed!' }
        failure { echo 'FAILED - Check logs above' }
    }
}