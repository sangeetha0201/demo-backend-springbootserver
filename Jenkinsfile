
pipeline {
    environment {
        registry = "sandeep4642/demo-backend-springbootserver" 
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
    agent any
    stages { 
        stages {
            stage('SonarQube analysis') {
                agent { label "master"}
                steps {
                    withSonarQubeEnv('local-sonar') {
                       bat 'mvn clean org.jacoco:jacoco-maven-plugin:prepare-agent install org.jacoco:jacoco-maven-plugin:report'
                       bat 'mvn sonar:sonar' 
                    }
                }
            }
            stage("Quality Gate") {
                agent { label "master"}
                steps {
                    sleep(60)
                    timeout(time: 3, unit: 'MINUTES') {
                        // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                        // true = set pipeline to UNSTABLE, false = don't
                        waitForQualityGate abortPipeline: false
                    }
                }
            }
        stage('maven build'){
            agent { label "master"}
            steps{
                bat 'mvn -DskipTests clean package'
                stash includes: 'target/*.jar', name: 'targetfiles'
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
	}
    }
