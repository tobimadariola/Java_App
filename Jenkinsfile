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
                    docker.build "$DOCKER_IMAGE_NAME"
                }
            }
        }
        stage('Push Image to Docker Hub') {
            steps {
                script {
                    echo "Logging in to Docker Hub..."
                    withCredentials([string(credentialsId: 'dockerPass', variable: 'dockerPass')]) {
                    sh 'docker login -u ceeepath -p $dockerPass'
                    sh 'docker push $DOCKER_IMAGE_NAME'
                    echo "Image pushed to docker hub"
                    }
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
