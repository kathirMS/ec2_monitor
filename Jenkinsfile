pipeline {
    agent any
    stages {
    
        
        stage ('Creating EC2 Instance State Change Alert') {
            steps {
                script {
                    try {
                         
                        sh '''#!/bin/bash
                            cd /var/lib/jenkins/workspace/Mydemo
                            sed -i -e "s|us-east-1|$AWS_REGION|g" -e "s|{account-name}|$AWS_PROFILE|g" main.tf
                            terraform init
                            terraform plan
                            terraform apply -var="provider_profile=$AWS_PROFILE provider_region=$AWS_REGION email=$EMAIL name=$SNS_NAME tag_key=$EC2_TAG_KEY tag_value=$EC2_TAG_VALUE customer=$CUSTER_TAG_VALUE cost_center=$COST_CENTER_TAG_VALUE"
                            
                            '''
                    }

                    catch (Exception err) {
                        currentBuild.result = 'FAILED'
                        sh '''#!/bin/bash
                               echo "cant deploy sumologic collector"
                               exit 1
                               '''
                    }
                }
            }
            
        }
      
    }
    
}    
