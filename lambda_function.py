import json
import boto3
import os

tag_key = os.environ['tag_key']
tag_value = os.environ['tag_value']
sns_topic_arn = os.environ['sns_topic_arn']
def lambda_handler(event, context):
    client = boto3.resource('ec2')
    instance_id = event['detail']['instance-id']
    instance_state = event['detail']['state']
    instance_metadata = client.Instance(instance_id)
    tags = instance_metadata.tags
    
    
    
    if not tags:
        print("No tags for this ec2 resource")
    else:
        for tag in tags:
            if tag['Key'].lower() == tag_key and tag['Value'].lower() == tag_value:
                client = boto3.client('sns')
                response = client.publish(TargetArn=sns_topic_arn,Message="the EC2 instance "+instance_id+" is in "+instance_state+" state",Subject="ALERT-AWS:EC2 is "+instance_state)
                break
            else:
                continue
            
                
