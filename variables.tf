# Define the AWS region where resources will be provisioned
variable "REGION" {
  description = "The AWS region to deploy the resources."
  default     = "us-east-1"
}

variable "ZONE" {
  description = "The availability zone within the region where the instance will be launched."
  default     = "us-east-1a"
}

# Define the AMI ID for the EC2 instance (default is Amazon Linux 2)
variable "AMI" {
  description = "The AMI ID to use for EC2 Instance (Amazon Linux 2)."
  default     = "ami-066784287e358dad1"
}

# Define the default username for SSH access
variable "USER" {
  description = "The default username for SSH access."
  default     = "ec2-user"
}

# Define the instance type for the EC2 instance
variable "INSTANCE_TYPE" {
  description = "The type of instance to start (e.g., t2.micro, t3.medium)."
  default     = "t2.micro"
}


# Define the VPC ID to deploy the instance (useful if you're deploying in an existing VPC)
variable "VPC_ID" {
  description = "The ID of the VPC where the resources will be deployed."
  default     = "vpc-07074832b4d27031b"
}

# Define the security group IDs to associate with the EC2 instance
variable "SECURITY_GROUP_IDS" {
  description = "A list of security group IDs to associate with the EC2 instance."
  type        = list(string)
  default     = ["sg-0671fca6ccac692a1"]
}

variable "SUBNET_ID" {
  description = "The ID of the subnet in which to launch the EC2 instance."
  default     = "subnet-0985812dad4345381"
}

# Define the EC2 instance tags
variable "TAGS" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default = {
    Name        = "MyEC2Instance"
    Environment = "Development"
  }
}

# Define the key name to use for SSH access to the EC2 instance
variable "KEY_NAME" {
  description = "The name of the key pair to use for SSH access to the instance."
  default     = "InstanceKey"
}

variable "EBS_VOLUME_SIZE" {
  description = "The size of the EBS volume in GB."
  default     = 8
}

variable "EBS_VOLUME_TYPE" {
  description = "The type of the EBS volume (gp3 for general purpose, standard for magnetic)."
  default     = "gp3"
}

variable "PRIVATE_KEY_PATH" {
  description = "The path to the private key file for SSH access."
  default     = "./InstanceKey.pem" # Path to your private key
}

