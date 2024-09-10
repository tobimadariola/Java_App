pipeline {
    agent any
    tools{maven "maven3"}

    environment {
        DOCKER_IMAGE = "${DOCKER_REGISTRY}/${IMAGE_NAME}"
        DOCKER_TAG = "v1.0.${BUILD_NUMBER}" // Define the Docker tag once
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
                    echo "Building Docker image ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    echo "Pushing Docker image ${DOCKER_IMAGE}:${DOCKER_TAG} to Docker Hub..."
                    
                    // Authenticating and pushing the image using Docker plugin
                    docker.withRegistry('', 'docker-hub-credentials') {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }
        stage('Cleanup Docker Image') {
            steps {
                script {
                    echo "Removing Docker image ${DOCKER_IMAGE}:${DOCKER_TAG} from Jenkins host..."
                    docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").remove()
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
