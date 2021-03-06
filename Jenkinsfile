pipeline {
    agent any
    options {
        disableConcurrentBuilds()
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/SirSkaro/Churchill-Casa-Database.git'
            }
        }
        stage('Inject Credentials') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'cookbook_mysql_user_credentials', passwordVariable: '$password', usernameVariable: '$username')]) {
                    script {
                        def text = readFile file: "init_scripts/cookbook.sql" 
                        text = text.replaceAll("%USERNAME%", $username).replaceAll("%PASSWORD%", $password)
                        writeFile file: "init_scripts/cookbook.sql", text: text
                    }
                }
            }
        }
        stage('Deploy MySQL') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'casa-mysql-root-credentials', passwordVariable: '$password', usernameVariable: '$username')]) {
                    sh 'docker stop casa-mysql || true && docker rm casa-mysql || true'
                    sh 'docker run -d \
                        --name casa-mysql \
                        --hostname 0.0.0.0 \
                        --network casa-net \
                        --restart always \
                        -v casa_mysql:/var/lib/mysql \
                        -e MYSQL_ROOT_PASSWORD=$password \
                        mysql:latest \
                        --log-bin-trust-function-creators=1'
                    sh 'sleep 3'
                }
            }
        }
        stage('Execute Scripts') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'casa-mysql-root-credentials', passwordVariable: 'password', usernameVariable: 'username')]) {
                    script {
                        findFiles(glob: 'init_scripts/*.sql').each { sqlScript ->
                            sh "docker exec -i casa-mysql mysql -u$username -p$password < init_scripts/${sqlScript.name}"
                        }
                    }
                }
            }
        }
    }
}


        
