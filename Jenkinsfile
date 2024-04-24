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
                docker run -v ./artifacts/build:/build -d --rm --name build_container react-hot-cold:latest
                docker cp build_container:/react-hot-cold/build .
                '''
            }
        }

        stage('Test') {
            steps {
                echo "Test stage"
                sh '''
                docker build -t react-hot-cold-test:latest -f ./test/Dockerfile .
                docker compose up test
                docker compose logs test >> log_test.txt
                '''
            }
        }
        stage('Deploy') {
            steps {
                echo "Deploy stage"
                sh '''
                
                docker build -t react-hot-cold-deploy:latest -f ./deploy/Dockerfile .
                docker run -p 3000:3000 -d --rm --name deploy_container react-hot-cold-deploy:latest
                '''
            }
        }

        stage('Publish') {
            steps {
                echo "Publish stage"
                sh '''
                TIMESTAMP=$(date +%Y%m%d%H%M%S)
                tar -czf artifact_$TIMESTAMP.tar.gz log_build.txt log_test.txt
                
                docker compose down
                
                '''

            } 
        }
    }
    post{
        always{
            echo "Archiving artifacts"
            archiveArtifacts artifacts: 'artifact_*.tar.gz', fingerprint: true
        }
    }
    
}