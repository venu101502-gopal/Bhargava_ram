pipeline {
    agent any
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    } 

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TF_WORKING_DIR        = '.'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform plan -out=tfplan -input=false'
                }
            }
        }

        steps {
               script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
           }
       }

       stage('Terraform Apply') {
    steps {
        input message: 'Approve Terraform apply?', ok: 'Apply'
        dir("${TF_WORKING_DIR}") {
            sh 'terraform apply -input=false -auto-approve tfplan'
        }
    }
}


    post {
        always {
            dir("${TF_WORKING_DIR}") {
                sh 'terraform fmt -check'
            }
        }
        failure {
            echo 'Pipeline failed.'
        }
        success {
            echo 'Terraform apply completed successfully!'
        }
    }
}
