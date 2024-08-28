
pipeline {
    agent any
    environment {
        DOCKERHUB_DEV_REPO = 'aartheshree/dev'
        DOCKERHUB_PROD_REPO = 'aartheshree/prod'
        GIT_REPO_URL = 'https://github.com/Aartheshree/devops-build.git'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the code from the Git repository
                git branch: env.BRANCH_NAME, url: "${GIT_REPO_URL}"
            }
        }
        stage('Build Docker Image') {
            steps {
                sh './build.sh'
            }
        }
        stage('Push to Docker Hub') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'master'
                }
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        if (env.BRANCH_NAME == 'dev') {
                            // Push the Docker image to the dev repository on Docker Hub
                            sh "docker tag react-app registry.hub.docker.com/${DOCKERHUB_DEV_REPO}:dev_latest"
                            sh "docker push registry.hub.docker.com/${DOCKERHUB_DEV_REPO}:dev_latest"
                        } else if (env.BRANCH_NAME == 'master') {
                            // Push the Docker image to the prod repository on Docker Hub
                            sh "docker tag react-app registry.hub.docker.com/${DOCKERHUB_PROD_REPO}:latest"
                            sh "docker push registry.hub.docker.com/${DOCKERHUB_PROD_REPO}:latest"
                        }
                    }
                }
            }
        }
       stage('Deploy') {
          steps {
                sh './deploy.sh'
            }
        }
    }
    post {
        success {
            echo 'Docker image successfully built and pushed to Docker Hub! React App is running!!'
        }
        failure {
            echo 'Build or push failed.'
        }
    }
}
