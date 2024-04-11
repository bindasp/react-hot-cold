pipeline {
agent any

    environment {
        GIT_REPO = 'https://https://github.com/bindasp/react-hot-cold'
        GIT_BRANCH = 'main'
    }

    triggers {
        pollSCM('* * * * *')
    }

    stages {

        stage('Build') {
            steps {
                echo "Build stage"
                sh '''
                docker build -t react-hot-cold:latest  -f./build/Dockerfile .
                '''
            }
        }

        stage('Test') {
            steps {
                echo "Test stage"
                sh '''
        
                docker build -t snake_tester:latest -f ./test/Dockerfile .
                '''
            }
        }
        stage('Deploy to staging') {
            steps {
                echo "Deploy to staging"
                sh '''
    
                docker-compose up
                docker-compose logs build > log.txt
                docker-compose logs test >> log.txt

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