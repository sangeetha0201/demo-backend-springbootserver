pipeline {
    environment {
        registry = "sandeep4642/demo-backend-springbootserver"    
        registryCredential = 'dockerhub'
        dockerImage = ''
        appname = "demo-backend-springbootserver"
      }
    agent { label "docker-slave"}
    stages {
        stage('maven build'){
            
            steps{
                sh 'mvn -DskipTests clean package'
                
            }
        }
  
        stage('Building Docker image') {
            steps{
              script {
                
                dockerImage = docker.build registry + ":$BUILD_NUMBER"
              }
            }
        
        }
        stage('Deploy push') {
            
            steps{
              script {
                docker.withRegistry( '', registryCredential ) {
                  dockerImage.push()
                }
              }
            }
          }
        stage('Remove Unused docker image') {
            
            steps{
              sh "docker rmi $registry:$BUILD_NUMBER"
            }
          }
	    stage('Deploy to Server'){
            
            steps{
                sh 'whoami'
                sh 'ansible-playbook /home/jenkins/demo-backend-deploy.yml --extra-vars "deploy_server=dev" --extra-vars "job_name=$registry"  --extra-vars "container_name=$appname" --extra-vars "build_no=$BUILD_NUMBER" --extra-vars "port_no=8080"'
                
            }
        }
        }
   }
