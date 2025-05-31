provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "venu_vpc" {
  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "Venu_vpc"
  }
}

resource "aws_internet_gateway" "venu_igw" {
  vpc_id = aws_vpc.venu_vpc.id

  tags = {
    Name = "Venu_IGW"
  }
}

resource "aws_subnet" "venu_public_subnet" {
  vpc_id                          = aws_vpc.venu_vpc.id
  cidr_block                      = "10.0.31.0/24"
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.venu_vpc.ipv6_cidr_block, 8, 31)
  availability_zone               = "us-east-1a"
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation  = true

  tags = {
    Name = "Venu_public_subnet"
  }
}

resource "aws_subnet" "venu_private_subnet" {
  vpc_id                          = aws_vpc.venu_vpc.id
  cidr_block                      = "10.0.32.0/24"
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.venu_vpc.ipv6_cidr_block, 8, 32)
  availability_zone               = "us-east-1b"
  map_public_ip_on_launch         = false

  tags = {
    Name = "Venu_private_subnet"
  }
}

resource "aws_route_table" "venu_public_route_table" {
  vpc_id = aws_vpc.venu_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.venu_igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.venu_igw.id
  }

  tags = {
    Name = "Venu_public_route_table"
  }
}

resource "aws_route_table_association" "venu_public_route_table_association" {
  subnet_id      = aws_subnet.venu_public_subnet.id
  route_table_id = aws_route_table.venu_public_route_table.id
}

resource "aws_security_group" "venu_security_group" {
  name        = "Venu_SG"
  description = "Allow access to ports 22, 80, 443, 10050, and 3306"
  vpc_id      = aws_vpc.venu_vpc.id

  ingress {
    description = "SSH access (restrict to your IP for security, e.g., your_ip_address/32)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with specific IP for better security
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Zabbix agent access"
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MySQL access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # All protocols
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Venu_SG"
  }
}

resource "aws_instance" "venu_instance" {
  ami                    = "ami-084568db4383264d4" # Verify this AMI exists in us-east-1
  instance_type          = "t2.micro"
  key_name               = "Ofc-key" # Ensure this key pair exists in your AWS account
  subnet_id              = aws_subnet.venu_public_subnet.id
  vpc_security_group_ids = [aws_security_group.venu_security_group.id]

  tags = {
    Name = "Venu_Gopal_205101"
  }
}
