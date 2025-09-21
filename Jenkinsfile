pipeline {
    agent {
        docker {
            image 'docker:24'
            args '--privileged -v jenkins-docker:/var/lib/docker -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    
    stages {

        stage('Checkout') {
            steps {
                deleteDir()
                git branch: 'master', url: 'https://github.com/richard7594/CI-CD.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker info'
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

