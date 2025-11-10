pipeline {
    agent any

    tools {
        "hudson.plugins.sonar.SonarRunnerInstallation" "SonarScanner"
    }

    environment {
        SONAR_PROJECT_KEY = 'ci-cd-demo'
        SONAR_PROJECT_NAME = 'ci-cd-demo'
        SONAR_SOURCES = 'src'
    }

    stages {
        stage('Checkout') {
            steps {
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

       stage('SonarQube Analysis') {
  steps {
    withSonarQubeEnv('MySonar') {
      script {
        def scannerHome = tool name: 'SonarScanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
        sh """
          ${scannerHome}/bin/sonar-scanner \
            -Dsonar.projectKey=ci-cd-demo \
            -Dsonar.projectName=ci-cd-demo \
            -Dsonar.sources=src
        """
      }
    }
  }
}


        stage('Build Docker Image') {
            steps {
                sh 'docker build -t demo-ci-cd:latest .'
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                sh 'docker-compose down || true'
                sh 'docker-compose up -d --build'
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }

    post {
        success {
            echo '✅ Déploiement réussi !'
        }
        failure {
            echo '❌ Le pipeline a échoué.'
        }
    }
}
