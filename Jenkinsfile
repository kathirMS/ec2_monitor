pipeline {
    agent {
		node {
			//label "${params.NODE}"
			customWorkspace "/home/ubuntu/workspace/ec2_state_change_alert_automation-script-${AWS_REGION}"
		}
    }
    stages {            
        stage ('Creating EC2 Instance State Change Alert') {
            steps {
                script {
                    try {
                         
                        sh '''#!/bin/bash
                            cd $WORKSPACE
                            sed -i -e "s|us-east-1|${AWS_REGION}|g" -e "s|{account-name}|${AWS_PROFILE}|g" main.tf
                            sudo terraform init
                            sudo terraform plan  
                            sudo terraform apply -var provider_profile="${AWS_PROFILE}" -var provider_region="${AWS_REGION}" -var email="${EMAIL}" -var name="${SNS_NAME}" -var tag_key="${EC2_TAG_KEY}" -var tag_value="${EC2_TAG_VALUE}" -var customer="${CUSTER_TAG_VALUE}" -var cost_center="${COST_CENTER_TAG_VALUE}" -auto-approve -lock=false
                            
                            '''
                    }

                    catch (Exception err) {
                        currentBuild.result = 'FAILED'
                        sh '''#!/bin/bash
                               echo "cant deploy ec2 instance state change alert"
                               exit 1
                               '''
                    }
                }
            }
            
        }
      
    }
    
} 
