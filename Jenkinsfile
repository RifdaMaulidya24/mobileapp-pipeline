pipeline {
    agent any

    environment {
        IMAGE_NAME = 'rifdamaulidya24/mobileapp-pipeline'
        REGISTRY = 'https://index.docker.io/v1/'
        REGISTRY_CREDENTIALS = 'dockerhub-credentials' // pastikan sesuai di Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Project') {
            steps {
                bat 'echo "🚀 Mulai build aplikasi..."'
                bat 'npm install'
                bat 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // 🧹 Bersihkan cache build agar image tidak menumpuk
                    bat 'docker builder prune -af || true'

                    // 🔧 Build image baru dengan tag sesuai nomor build Jenkins
                    bat "docker build -t ${IMAGE_NAME}:${env.BUILD_NUMBER} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // ⏰ Tambahkan timeout agar tidak menggantung terlalu lama
                    timeout(time: 5, unit: 'MINUTES') {
                        docker.withRegistry(env.REGISTRY, env.REGISTRY_CREDENTIALS) {
                            def tag = "${IMAGE_NAME}:${env.BUILD_NUMBER}"

                            // 🚢 Push image dengan tag build number
                            bat "docker push ${tag}"

                            // 🏷️ Tag juga sebagai 'latest' agar mudah di-pull versi terbaru
                            bat "docker tag ${tag} ${IMAGE_NAME}:latest"
                            bat "docker push ${IMAGE_NAME}:latest"
                        }
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    // 🧽 Bersihkan image lokal agar storage Jenkins tidak penuh
                    bat "docker rmi ${IMAGE_NAME}:${env.BUILD_NUMBER} || true"
                    bat "docker rmi ${IMAGE_NAME}:latest || true"
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build & Push Docker Image berhasil!'
        }
        failure {
            echo '❌ Build gagal. Periksa log untuk detail error.'
        }
        always {
            echo '🧾 Pipeline selesai dijalankan.'
        }
    }
}
