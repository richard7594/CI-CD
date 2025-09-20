pipeline {
    agent {
        docker {
            image 'docker:24-dind'
            args '--privileged -v jenkins-docker:/var/lib/docker'
        }
    }
    
    stages {

        stage('Build') {
            steps {
                sh 'docker info'
                sh 'docker build -t demo-ci-cd:latest .'
            }
        }
        stage('Checkout') {
            steps {
                deleteDir()
                git branch: 'master', url: 'https://github.com/richard7594/CI-CD.git'
            }
        }

        stage('Build1') {
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
