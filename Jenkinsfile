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
                docker compose logs building > log.txt
                docker compose logs test >> log.txt

                '''
            }
        }

        stage('Deploy to production') {
            steps {
                echo "Deploy to production"
                sh '''
                TIMESTAMP=$(date +%Y%m%d%H%M%S)
                tar -czf Artifact_$TIMESTAMP.tar.gz ./Snake_files/artifacts ./Snake_files/docker-compose.yml ./Snake_files/tests ./Snake_files/build ./Snake_files/log.txt
                ls -l
                cd Snake_files/
                docker compose down
                '''
                echo "Archiving the artifact..."
                archiveArtifacts artifacts: 'Artifact_*.tar.gz', fingerprint: true
            }
        }
    }
}