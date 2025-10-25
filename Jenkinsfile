pipeline {
    agent any
    environment {
        IMAGE_NAME = 'rifdamaulidya24/mobileapp-pipeline'
        REGISTRY = 'https://index.docker.io/v1/'
        REGISTRY_CREDENTIALS = 'dockerhub-credentials'  // pastikan sesuai dengan yang kamu buat di Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Project') {
            steps {
                bat 'echo "Mulai build aplikasi..."'
                bat 'npm install'
                bat 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat 'docker builder prune -af || true'
                    bat "docker build -t ${IMAGE_NAME}:${env.BUILD_NUMBER} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry(env.REGISTRY, env.REGISTRY_CREDENTIALS) {
                        def tag = "${IMAGE_NAME}:${env.BUILD_NUMBER}"
                        bat "docker push ${tag}"
                        bat "docker tag ${tag} ${IMAGE_NAME}:latest"
                        bat "docker push ${IMAGE_NAME}:latest"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Selesai build'
        }
    }
}

