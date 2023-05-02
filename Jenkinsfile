pipeline {
    environment {
        registry = "sandeep4642/demo-backend-springbootserver"    
        registryCredential = 'dockerhub'
        dockerImage = ''
      }
    agent any
    stages {
        stage('maven build'){
            agent { label "master"}
            steps{
                bat 'mvn -DskipTests clean package'
                stash includes: 'target/*.jar', name: 'targetfiles'
            }
        }
        stage ('Upload') {
            agent { label "master"}
            steps {
            rtUpload (
			serverId: 'jfrog-creds',
			spec: '''{
				"files": [
					{
					"pattern": "**/*.jar",
					"target": "demo-backend-springbootserver/"
					}
				]
			}''',

        )
            }
        }  
        stage('Building Docker image') {
            agent { label "docker-slave"}
            steps{
              script {
                unstash 'targetfiles'
                dockerImage = docker.build registry + ":$BUILD_NUMBER"
              }
            }
        
        }
        stage('Deploy push') {
            agent { label "docker-slave"}
            steps{
              script {
                docker.withRegistry( '', registryCredential ) {
                  dockerImage.push()
                }
              }
            }
          }
        stage('Remove Unused docker image') {
            agent { label "docker-slave"}
            steps{
              sh "docker rmi $registry:$BUILD_NUMBER"
            }
          }
	    stage('Deploy to Server'){
            agent { label "docker-slave"}
            steps{
                sh 'whoami'
                sh 'ansible-playbook /home/jenkins/demo-backend-deploy.yml --extra-vars "job_name=$JOB_NAME" --extra-vars "build_no=$BUILD_NUMBER" --extra-vars "port_no=8080"'
                
            }
        }
        }
   }
