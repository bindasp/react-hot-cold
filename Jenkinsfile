pipeline {
agent any

    environment{
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_IMAGE_VERSION = '1.0'
    }

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
                docker run --name build_container react-hot-cold:latest
                docker cp build_container:/react-hot-cold/build ./artefakty
                docker logs build_container > log_build.txt
                '''
            }
        }

        stage('Test') {
            steps {
                echo "Test stage"
                sh '''
                docker build -t react-hot-cold-test:latest -f ./test/Dockerfile .
                docker run --name test_container react-hot-cold-test:latest
                docker logs test_container > log_test.txt

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
                tar -czf artifact_$TIMESTAMP.tar.gz log_build.txt log_test.txt artefakty
                
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                NUMBER='''+ env.BUILD_NUMBER +'''
                docker tag react-hot-cold-deploy:latest bindasp/react-hot-cold:$DOCKER_IMAGE_VERSION
                docker tag react-hot-cold-deploy:latest bindasp/react-hot-cold:latest
                docker push bindasp/react-hot-cold:$DOCKER_IMAGE_VERSION
                docker push bindasp/react-hot-cold:latest
                docker logout

                '''
            } 
        }
    }
    post{
        always{
            echo "Archiving artifacts"

            archiveArtifacts artifacts: 'artifact_*.tar.gz', fingerprint: true
            sh '''
            chmod +x cleanup.sh
            ./cleanup.sh
            '''
        }
        success{
           DOCKER_IMAGE_VERSION = incrementVersion(DOCKER_IMAGE_VERSION)
        }
    }
    
}

def incrementVersion(version) {
    def parts = version.tokenize('.')
    def major = parts[0] as int
    def minor = parts[1] as int
    def patch = parts[2] as int
    patch++
    return "${major}.${minor}.${patch}"
}