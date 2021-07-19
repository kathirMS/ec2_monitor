 
 1. create a sns
 2. create a rule
 3. create a lambda function
  
### 1.SNS( Simple Notification Service )

*  Simple Notification Service using to send message to mail
### 2.Rule(Cloudwatch Event)

* This rule is when change the state of ec2 instance that time trigger the lambda function 
### 3.Lambda Function

* This Lambda using to filter the ec2 instance using tag_key,tag_value.then trigger the SNS

# AWS Permission To User To Run this script

  1. AmazonSNSFullAccess
  2. CloudWatchEventsFullAccess
  3. AWSLambda_FullAccess
  4. AmazonS3FullAccess

# Run Script

#### placeholders

Using the placeholders in our Script modify the value  in run time using Shell script   -->{account-name} 

### INPUTS Variables

   provider_profile,provider_region,email,name,tag_key,tag_value
   
     Terraform init
     Terraform plan
     terraform apply
