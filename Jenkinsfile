pipeline {
    agent any
    tools{maven "maven3"
          dockerTool "docker"
         }

    environment {
        DOCKER_IMAGE = "ceeepath/java-app"
        DOCKER_TAG = "1.0.${BUILD_NUMBER}" // Define the Docker tag once
        DOCKER_IMAGE_NAME = "${DOCKER_IMAGE}:${DOCKER_TAG}"
    }

    stages {
        stage('Building Artifat') {
            steps {
                echo 'Running Maven clean and package...'
                sh 'mvn clean package'
                }
            }

        stage('Build Test') {
            steps {
                echo 'Running Maven tests...'
                sh 'mvn test'
                }
            }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image $DOCKER_IMAGE_NAME"
                    dockerImage = docker.build DOCKER_IMAGE + ":$DOCKER_TAG"
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo "Pushing Docker image $DOCKER_IMAGE_NAME to Docker Hub..."
                    
                    docker.withRegistry( '', docker-hub-credentials ) 
                }
            }
        }
        stage('Cleanup Docker Image') {
            steps {
                script {
                    echo "Removing Docker image $DOCKER_IMAGE_NAME from Jenkins host..."
                    sh "docker rmi $DOCKER_IMAGE_NAME"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline completed!"
        }
    }
}
