#<----profile of the provider----->
 
   variable "rovider_profile"{
   type=string
   default="aws-devops-test"
}

#<----region of the provider----->

variable "provider_region"{
   type=string
   default="us-east-1"
}

#<----Email of Topic----->

variable "email"{
   type=string
   default="w7q9c4x9d0l9d8a6@batonsystems.slack.com"
}

#<-----Name Of SNS------>

variable "name" {
   
   type=string    
   default = "All_Ec2_Instance_State_Change_Alert"
}

#<-----tag_key_of_instance------->

variable "tag_key" {
   type=string
   default="env1"
}

#<-----tag_value_of_instance------->

variable "tag_value" {
   type=string
   default="test1"
}

#<-----tag_value_of_customer------->

variable "customer" {
   type=string
   default="citi"
}

#<-----tag_value_of_cost_center------->

variable "cost_center" {
   type=string
   default="test1"
}


