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
                sh 'docker build -t oayanda/todo:$GIT_BRANCH-0.0.$BUILD_NUMBER .'
            }
        }
        stage('login to dockerhub') {
            steps{
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('push image') {
            steps{
                sh 'docker push oayanda/todo:$GIT_BRANCH-0.0.$BUILD_NUMBER'
            }
        }
       stage('Cleanup') {
			steps {
				cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenUnstable: true, deleteDirs: true)
				
				sh 'docker logout'

				
			}
		}
    }
// post {
//         always {
//             sh 'docker logout'
//         }
//     }
    // stage('Clean Workspace After Buiild'){
    //     steps{
    //        CleanWs()
    //     }
    // }
}
