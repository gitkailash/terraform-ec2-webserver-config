# Terraform EC2 Instance Provisioning

This repository provides Terraform configuration files for provisioning an AWS EC2 instance and deploy apache webserver with additional settings, such as EBS volumes, provisioners, and SSH access.

## Architecture Diagram

![Architecture Diagram](https://github.com/gitkailash/terraform-ec2-webserver-config/blob/main/img/Terraform%20ec2%20provision.jpg)

---

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [Usage](#usage)
- [Provisioners](#provisioners)
- [Example `web.sh` Script](#example-websh-script)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## 📦 Prerequisites

1. **Terraform**: Download and install Terraform from [Terraform's website](https://www.terraform.io/downloads.html).
2. **AWS CLI**: Install and configure AWS CLI from [AWS CLI's website](https://aws.amazon.com/cli/).
3. **AWS Key Pair**: Create or use an existing AWS key pair. Ensure the key pair name is specified in the `KEY_NAME` variable.

## 🔧 Configuration

### Variables

Update the `variables.tf` file with the necessary details. Here’s a template:

```hcl
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

# Define the subnet
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


```

### Example `instance.tf` File

Create a `instance.tf` file with the following content:

```hcl
provider "aws" {
  region = var.REGION
}

resource "aws_instance" "Web_Server" {
  ami                    = var.AMI
  instance_type          = var.INSTANCE_TYPE
  key_name               = var.KEY_NAME
  vpc_security_group_ids = var.SECURITY_GROUP_IDS
  subnet_id              = var.SUBNET_ID
  availability_zone      = var.ZONE
  tags                   = var.TAGS

  # Add EBS volume configuration
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.EBS_VOLUME_SIZE
    volume_type           = var.EBS_VOLUME_TYPE
    delete_on_termination = true
  }

  # Copy the script to the EC2 instance
  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"

    # Specify the connection for the file provisioner
    connection {
      type        = "ssh"
      user        = var.USER
      private_key = file(var.PRIVATE_KEY_PATH) # Path to your private key
      host        = self.public_ip
    }
  }

  # Run the script on the EC2 instance
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]

    connection {
      type        = "ssh"
      user        = var.USER
      private_key = file(var.PRIVATE_KEY_PATH) # Path to your private key
      host        = self.public_ip
    }
  }
}

```

## 🚀 Usage

Follow these steps to deploy the EC2 instance:

1. **Initialize Terraform:**

   Initialize the Terraform working directory to download provider plugins:

   ```bash
   terraform init
   ```

2. **Validate Configuration:**

   Ensure that your configuration files are valid:

   ```bash
   terraform validate
   ```

3. **Format Configuration:**

   Format the configuration files for consistent styling:

   ```bash
   terraform fmt
   ```

4. **Create Execution Plan:**

   Generate an execution plan to review proposed changes:

   ```bash
   terraform plan
   ```

5. **Apply Configuration:**

   Apply the configuration to create or update resources:

   ```bash
   terraform apply
   ```

6. **Clean Up:**

   To destroy the resources created by Terraform:

   ```bash
   terraform destroy
   ```

## 🛠 Provisioners

- **File Provisioner:** Copies `web.sh` script to `/tmp` directory on the EC2 instance.
- **Remote-Exec Provisioner:** Executes the `web.sh` script on the EC2 instance.

## 📝 Example `web.sh` Script

Here’s a simple script example that installs Apache HTTP Server:

```bash
#!/bin/bash

# Update the package index
echo "Updating package index..."
sudo yum update -y

# Install httpd (Apache)
echo "Installing httpd..."
sudo yum install httpd -y

# Start the httpd service
echo "Starting httpd service..."
sudo systemctl start httpd

# Enable httpd to start on boot
echo "Enabling httpd to start on boot..."
sudo systemctl enable httpd

# Open HTTP port 80 in the firewall (if applicable)
echo "Allowing HTTP traffic on port 80..."
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload

# Restart httpd service
echo "Restarting httpd Service..."
sudo systemctl restart httpd

# Confirm httpd service status
echo "Checking httpd service status..."
sudo systemctl status httpd

echo "httpd installation and configuration complete."

```

Save this script as `web.sh` in the same directory as your Terraform configuration files.

## 🛠 Troubleshooting

- **SSH Authentication Error:**
  Ensure the private key file (`InstanceKey.pem`) has correct permissions:

  ```bash
  chmod 400 ./InstanceKey.pem
  ```

- **Invalid Key Path:**
  Verify the path to the private key file is correctly specified in the `PRIVATE_KEY_PATH` variable.

## 📝 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
