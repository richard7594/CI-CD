pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'git@github.com:richard7594/CI-CD.git'
            steps {
                sh 'npm test'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t demo-ci-cd:latest .'
            }
        }
        stage('Deploy with Docker Compose') {
            steps {
                sh 'docker-compose down && docker-compose up -d'
            }
        }
    }
}

