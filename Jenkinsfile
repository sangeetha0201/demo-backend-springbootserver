
pipeline {
    environment {
        registry = "sandeep4642/demo-app" 
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
    agent { label 'slave'}
    stages { 
        stage ('Build') {
            steps {
                sh 'mvn -DskipTests clean package'
            }
        }

        stage ('Build Docker image') {
            steps {
                script { 
                dockerImage = docker.build registry + ":$BUILD_NUMBER" 
            } 
            }
        }
        stage('Deploy our image into Registry') { 
            steps { 
                script { 
                    docker.withRegistry( '', registryCredential ) { 
                    dockerImage.push() 
                    }
                } 
            }
        }
        stage('Cleaning up') { 
            steps { 
                sh "docker rmi $registry:$BUILD_NUMBER" 
            }
        }
    }
}
