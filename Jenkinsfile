pipeline {
  agent any

  environment {
    IMAGE_NAME = 'rifdamaulidya24/mobileapp-pipeline'
    REGISTRY = 'https://index.docker.io/v1/'
    REGISTRY_CREDENTIALS = 'dockerhub-credentials'
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
        // Gunakan "bat" karena Windows pakai cmd, bukan sh
        bat 'npm install'
      }
    }

    stage('Build Application') {
      steps {
        echo '=== Build aplikasi Vite ==='
        bat 'npm run build'
      }
    }

    stage('Build Docker Image') {
      steps {
        echo '=== Membuat Docker image ==='
        script {
          bat "docker build -t ${IMAGE_NAME}:${env.BUILD_NUMBER} ."
        }
      }
    }

    stage('Push Docker Image to DockerHub') {
      steps {
        echo '=== Push Docker image ke DockerHub ==='
        script {
          withDockerRegistry([url: env.REGISTRY, credentialsId: env.REGISTRY_CREDENTIALS]) {
            bat "docker pu
