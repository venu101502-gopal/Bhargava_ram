provider "aws" {
  region = "us-east-2"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get all subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get default security group in the default VPC
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_instance" "venugopal" {
  ami                    = "ami-0f9de6e2d2f067fca" # Replace with a valid AMI if needed
  instance_type          = "t2.micro"
  key_name               = "Blue-key" # Make sure this key exists in us-east-2
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [data.aws_security_group.default.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }

  dynamic "ebs_block_device" {
    for_each = {
      "/dev/xvdf" = 10,
      "/dev/xvdg" = 20,
      "/dev/xvdh" = 30
    }

    content {
      device_name           = ebs_block_device.key
      volume_size           = ebs_block_device.value
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  user_data = <<-EOF
    #!/bin/bash
    exec > /var/log/user-data.log 2>&1

    mkfs.xfs -f /dev/xvdf
    mkfs.xfs -f /dev/xvdg
    mkfs.xfs -f /dev/xvdh

    mkdir -p /home/ibtbackup /opt/sutisoftapps /var/lib/mysql

    mount /dev/xvdf /home/ibtbackup
    mount /dev/xvdg /opt/sutisoftapps
    mount /dev/xvdh /var/lib/mysql

    echo "$(blkid -s UUID -o value /dev/xvdf) /home/ibtbackup xfs defaults,nofail 0 2" >> /etc/fstab
    echo "$(blkid -s UUID -o value /dev/xvdg) /opt/sutisoftapps xfs defaults,nofail 0 2" >> /etc/fstab
    echo "$(blkid -s UUID -o value /dev/xvdh) /var/lib/mysql xfs defaults,nofail 0 2" >> /etc/fstab
  EOF

  tags = {
    Name = "Bhrgava_Ram"
  }
}
