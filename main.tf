provider "aws" {
  region = "us-east-1"
}

# Create a new VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my_vpc"
  }
}

# Create a public subnet in the VPC
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "my_subnet"
  }
}

# Internet Gateway for the VPC (to allow internet access)
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}

# Route table with default route to IGW
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my_route_table"
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "my_route_table_assoc" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Security Group allowing SSH and all outbound traffic
resource "aws_security_group" "my_sg" {
  name        = "my_security_group"
  description = "Allow SSH and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_security_group"
  }
}

# Get latest Amazon Linux 2 AMI in the region
data "aws_ssm_parameter" "amazon_linux_2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-ebs"
}

# EC2 Instance with additional EBS volumes and user data
resource "aws_instance" "venugopal" {
  ami                    = data.aws_ssm_parameter.amazon_linux_2_ami.value
  instance_type          = "t2.micro"
  key_name               = "Blue-key"   # Ensure this key pair exists in us-east-2
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
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
