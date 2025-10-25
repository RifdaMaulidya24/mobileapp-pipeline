pipeline {
  agent any

  environment {
    // Nama image di Docker Hub (sesuaikan dengan akun Docker Hub kamu)
    IMAGE_NAME = 'rifdamaulidya24/my-mobileapp'
    REGISTRY = 'https://index.docker.io/v1/'
    REGISTRY_CREDENTIALS = 'dockerhub-credentials'  // credential ID yang kamu buat di Jenkins
  }

  stages {
    stage('Checkout Source Code') {
      steps {
        echo '=== Checkout Repository dari Git ==='
        checkout scm
      }
    }

    stage('Install Dependencies') {
      steps {
        echo '=== Install dependencies project ==='
        // Di Windows, gunakan "bat" jika Jenkins agent kamu Windows, gunakan "sh" jika Linux
        sh 'npm install'
      }
    }

    stage('Build Application') {
      steps {
        echo '=== Build aplikasi Vite ==='
        sh 'npm run build'
      }
    }

    stage('Build Docker Image') {
      steps {
        echo '=== Build Docker image dari Dockerfile ==='
        script {
          docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
        }
      }
    }

    stage('Push Docker Image to DockerHub') {
      steps {
        echo '=== Push image ke DockerHub ==='
        script {
          docker.withRegistry("${REGISTRY}", "${REGISTRY_CREDENTIALS}") {
            def tag = "${IMAGE_NAME}:${BUILD_NUMBER}"
            docker.image(tag).push()
            docker.image(tag).tag('latest')
            docker.image("${IMAGE_NAME}:latest").push()
          }
        }
      }
    }

    stage('Deploy (Run Container)') {
      steps {
        echo '=== Menjalankan container dari image terbaru ==='
        script {
          // Stop container lama jika ada
          sh 'docker rm -f my_mobileapp_container || true'

          // Jalankan container baru
          sh "docker run -d -p 5173:5173 --name my_mobileapp_container ${IMAGE_NAME}:latest"
        }
      }
    }
  }

  post {
    always {
      echo 'Pipeline selesai dijalankan 🚀'
    }
  }
}
