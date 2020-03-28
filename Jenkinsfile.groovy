pipeline {
    agent any
    environment {
        AZURE_CRED=credentials('AZURE_CRED')
        AZURE_ID=credentials('AZURE_ID')
        client_id="${AZURE_CRED_USR}"
        client_secret="${AZURE_CRED_PSW}"
        tenant_id="${AZURE_ID_USR}"
        subscription_id="${AZURE_ID_PSW}"
        location="australiaeast"
        ARM_CLIENT_ID="${AZURE_CRED_USR}"
        ARM_CLIENT_SECRET="${AZURE_CRED_PSW}"
        ARM_TENANT_ID="${AZURE_ID_USR}"
        ARM_SUBSCRIPTION_ID="${AZURE_ID_PSW}"
    }
    stages {
        // stage('Checkout repo') {
        //     steps {
        //         git branch: 'master',
        //         credentialsId: 'mygitcredid',
        //         url: 'https://github.com/rohitgabriel/azure-automation.git'
        //     }
        // }
        // stage("Packer build") {
        //     steps {
        //         sh '''
        //         ./build-image-with-packer.sh
        //         '''
        //     }
        // }
        stage("terraform init") {
            steps {
                sh """
                /usr/local/bin/terraform init -input=false
                """
            }
        }
        stage("terraform plan") {
            steps {
                sh '''
                /usr/local/bin/terraform plan -out=tfplan -input=false
                '''
            }
        }
        stage("Approval required") {
            input {
            message "Apply or Abort?"
            }
            steps {
                echo 'Terraform state is maintained at app.terraform.io, org: int, workspace: azure-automation'
            }
        }
        stage("terraform apply") {
            steps {
                sh '''
                /usr/local/bin/terraform apply -input=false tfplan
                '''
            }
        }
        // stage("Refresh Instance in ASG") {
        //     steps {
        //         withAWS(credentials: 'TerraformAWSCreds', region: 'ap-southeast-2') {
        //         sh './refresh-asg.sh'
        //       }
        //     }
        // }
        stage("clean up") {
            steps {
                sh '''
                rm ./tfplan
                '''
            }
        }
    }
}