pipeline {
agent any

    triggers {
        pollSCM('* * * * *')
    }

    stages {
        
        stage('Pull'){
            steps{
                echo "Pulling repo stage"
                git branch: 'main', credentialsId: 'be5b6235-4b9b-4fbe-b7ef-3bba7d729852', url: 'https://github.com/bindasp/react-hot-cold'
     
            }
        }
        
        stage('Build') {
            steps {
                echo "Build stage"
                sh '''
                docker build -t react-hot-cold:latest  -f./building/Dockerfile .
                '''
            }
        }

        stage('Test') {
            steps {
                echo "Test stage"
                sh '''
                docker build -t react-hot-cold:latest -f ./test/Dockerfile .
                '''
            }
        }
        stage('Deploy to staging') {
            steps {
                echo "Deploy to staging"
                sh '''

                docker compose up
                docker compose logs building > log_build.txt
                docker compose logs test >> log_test.txt

                '''
            }
        }

        stage('Deploy to production') {
            steps {
                echo "Deploy to production"
                sh '''
                TIMESTAMP=$(date +%Y%m%d%H%M%S)
                mkdir artifact_$TIMESTAMP
                cp log_build.txt artifact_$TIMESTAMP
                cp log_test.txt artifact_$TIMESTAMP
                

                docker compose down
                '''


            } 
        }
    }
    post{
        always{
            echo "Archiving artifacts"
            archiveArtifacts artifacts: 'artifact_*', fingerprint: true
        }
    }
}