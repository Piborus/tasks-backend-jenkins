pipeline {
    agent any
    stages {
        stage('Build BackEnd') {
            steps {
                echo 'mvn clean package -DskipTests=true'
            }
        }
    }
}