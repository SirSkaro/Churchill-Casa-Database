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
                sh 'echo "In credentials"'
                withCredentials([usernamePassword(credentialsId: 'cookbook_mysql_user_credentials', passwordVariable: '$password', usernameVariable: '$username')]) {
                    script {
                        def text = readFile file: "init_scripts/cookbook.sql"
                        text = text.replaceAll("%USERNAME%", $username).replaceAll("%PASSWORD%", $password)
                        writeFile file: "init_scripts/cookbook.sql", text: text
                        echo text
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                withCredentials([string(credentialsId: 'casa-mysql-root-password', variable: 'root_password')]) {
                    sh 'docker stop casa-mysql || true && docker rm casa-mysql || true'
                    sh 'docker run -d \
                        --name casa-mysql \
                        --network casa-net \
                        --restart always \
                        -v casa_mysql:/var/lib/mysql \
                        -v init_scripts:/docker-entrypoint-initdb.d \
                        -e MYSQL_ROOT_PASSWORD=$root_password \
                        mysql:latest'
                }
            }
        }
    }
}


        
