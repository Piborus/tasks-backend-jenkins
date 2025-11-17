pipeline {
    agent any
    stages {
        stage('Build BackEnd') {
            steps {
                bat 'mvn clean package -DskipTests=true'
            }
        }
        stage('Unit Tests') {
            steps {
                bat 'mvn test'
            }
        }
         stage('Sonar Analysis') {
            environment {
                scannerHome = tool 'SONAR_SCANNER'
            }
            steps {
                withSonarQubeEnv('SONAR_LOCAL') {
                bat "${scannerHome}/bin/sonar-scanner -e -Dsonar.projectKey=DeployBack -Dsonar.host.url=http://localhost:9000 -Dsonar.login=98367daf223547951f1d398f491c2a77ffecdf83 -Dsonar.java.binaries=target -Dsonar.coverage.exclusions=**/.mvn/**,**/src/test/**,**/model/**,**Application.java "
                }
            }
        }
        stage('Quality Gate') {
            steps {
                sleep(60)
                timeout(time: 1, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true

            }
        }
    }
    stage('Deploy Backend'){
        steps {
            deploy adapters: [tomcat9(credentialsId: 'TomCatLogin', path: '', url: 'http://localhost:8001/')], contextPath: 'tasks-backend', war: 'target/tasks-backend.war'
        }
    }
    stage('API Test'){
        steps {
            git branch: 'main', credentialsId: 'github_login', url: 'https://github.com/Piborus/tasks-api-test'
            bat 'mvn test'
        }
    }

    }
}

