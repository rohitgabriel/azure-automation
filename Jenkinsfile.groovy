pipeline {
    agent any
    environment {
        AZURE_CRED=credentials('AZURE_CRED')
        // AZURE_ID=credentials('AZURE_ID')
        AZUREPUB=credentials('AZUREPUB')
        // client_id="${AZURE_CRED_USR}"
        // client_secret="${AZURE_CRED_PSW}"
        // tenant_id="${AZURE_ID_USR}"
        // subscription_id="${AZURE_ID_PSW}"
        // location="australiaeast"
        
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
                        // export TF_VAR_ARM_CLIENT_ID="${AZURE_CRED_USR}"
                // export TF_VAR_ARM_CLIENT_SECRET="${AZURE_CRED_PSW}"
                // export TF_VAR_ARM_TENANT_ID="${AZURE_ID_USR}"
                // export TF_VAR_ARM_SUBSCRIPTION_ID="${AZURE_ID_PSW}"
        stage("terraform init") {
            steps {
                sh """
                /usr/local/bin/terraform init -input=false
                """
            }
        }
        stage("terraform plan") {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: 'AZURE_ACCOUNT_CREDS',
                                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                                    clientIdVariable: 'ARM_CLIENT_ID',
                                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                                    tenantIdVariable: 'ARM_TENANT_ID')]) {
                sh '''

                export TF_VAR_sshkey="${AZUREPUB_PSW}"
                /usr/local/bin/terraform plan -out=tfplan -input=false -var 'ARM_SUBSCRIPTION_ID="${ARM_SUBSCRIPTION_ID}"' -var 'ARM_CLIENT_ID="${ARM_CLIENT_ID}"' -var 'ARM_CLIENT_SECRET="${ARM_CLIENT_SECRET}"' -var 'ARM_TENANT_ID="${ARM_TENANT_ID}"'
                '''
                }
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
                withCredentials([azureServicePrincipal(credentialsId: 'AZURE_ACCOUNT_CREDS',
                                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                                    clientIdVariable: 'ARM_CLIENT_ID',
                                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                                    tenantIdVariable: 'ARM_TENANT_ID')]) {
                sh '''

                export TF_VAR_sshkey="${AZUREPUB_PSW}"
                /usr/local/bin/terraform apply -input=false tfplan -var 'ARM_SUBSCRIPTION_ID="${ARM_SUBSCRIPTION_ID}"' -var 'ARM_CLIENT_ID="${ARM_CLIENT_ID}"' -var 'ARM_CLIENT_SECRET="${ARM_CLIENT_SECRET}"' -var 'ARM_TENANT_ID="${ARM_TENANT_ID}"'
                '''
                }
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