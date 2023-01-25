pipeline {
    agent any 
    environment {
    DOCKERHUB_CREDENTIALS = credentials('oayanda-dockerhub')
    }
    stages { 
        stage("Initial cleanup") {
			steps {
				dir("${WORKSPACE}") {
					deleteDir()
				}
			}
		}
        stage('SCM Checkout') {
            steps{
            git branch: 'main', url: 'https://github.com/oayanda/Todo_App.git'
            }
        }

        stage('Build docker image') {
            steps {  
                sh 'docker build -t oayanda/phptodo:$GIT_BRANCH-0.0.$BUILD_NUMBER .'
            }
        }
      
       stage('Creating docker container') {
            steps {
                script {
                    sh " docker compose -f todo.yaml  up -d"
                }
            }
        }

        stage("Smoke Test") {
            steps {
                script {
                    sh "sleep 10"
                    "curl -I 44.198.185.86:8000"
                }
            }
        }
      
        stage('login to dockerhub') {
            steps{
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
      
        stage('push image') {
            steps{
                sh 'docker push oayanda/phptodo:$GIT_BRANCH-0.0.$BUILD_NUMBER'
            }
        }
      
       stage('Cleanup') {
			steps {
				cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenUnstable: true, deleteDirs: true)
				
				sh " docker rm ${docker ps -q}"
				//sh " docker rmi ${docker images}"
                   			
			}
		}
      
      stage ('logout Docker') {
            steps {
                script {
                    sh " docker logout"
                }
            }
        }
    }

}
