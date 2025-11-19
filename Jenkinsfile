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
                    sleep(30)
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
                dir('api-test') {
                    git branch: 'main', credentialsId: 'github_login', url: 'https://github.com/Piborus/tasks-api-test'
                    bat 'mvn test'
                }       
            
            }
        }
        stage('Deploy Frontend') {
            steps {
                dir('frontend') {
                    git branch: 'master', credentialsId: 'github_login', url: 'https://github.com/Piborus/tasks-frontend-jenkins'
                    bat 'mvn clean package'
                    deploy adapters: [tomcat9(credentialsId: 'TomCatLogin', path: '', url: 'http://localhost:8001/')], contextPath: 'tasks', war: 'target/tasks.war'
                }
            }
        }
        // stage('Functional Test'){
        //     steps {
        //         dir('functional-test') {
        //             git branch: 'main', credentialsId: 'github_login', url: 'https://github.com/Piborus/task-functional-test'
        //             bat 'mvn test'
        //         }       
            
        //     }
        // }
        stage('Deploy Prod'){
            steps {
                bat 'docker-compose build'
                bat 'docker-compose up -d'
            }
        }
        stage('Health Check'){
            steps {
                sleep(30)
                dir('health-check') {
                    git branch: 'main', credentialsId: 'github_login', url: 'https://github.com/Piborus/task-functional-test'
                    bat 'mvn verify -DskipSurefireTests'
                }       
            
            }
        }

    }
    post {
        always {
            junit allowEmptyResults: true, stdioRetention: '', testResults: 'target/surefire-reports/*.xml, api-test/target/surefire-reports/*.xml, functional-test/target/surefire-reports/*.xml, functional-test/target/failsafe-reports/*.xml'
            archiveArtifacts artifacts: 'target/tasks-backend.war, frontend/target/tasks.war, ', followSymlinks: false, onlyIfSuccessful: true
        }
        success {
            emailext attachLog: true, body: 'Foi um sucesso', subject: 'Build $BUILD_NUMBER has success', to: 'haroldomorais92+jenkins@gmail.com'
        }
        failure {
            emailext attachLog: true, body: 'Houve uma falha', subject: 'Build $BUILD_NUMBER has failed', to: 'haroldomorais92+jenkins@gmail.com'
        }
        fixed {
            emailext attachLog: true, body: 'Build corrigido', subject: 'Build $BUILD_NUMBER has been fixed', to: 'haroldomorais92+jenkins@gmail.com'
        }
    }
}

