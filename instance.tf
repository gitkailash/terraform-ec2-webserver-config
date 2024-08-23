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
