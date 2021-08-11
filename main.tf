provider "aws" {
  region = "us-west-1"
}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}
variable "mypub_key" {}
variable "public_key_location" {}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name"               = "${var.env_prefix}-vpc"
    yor_trace            = "68a2cee4-4283-44a6-962b-a48177b8abf2"
    git_commit           = "6bcb2a55d93e3bd8054281e3b7d3daf71ad698c5"
    git_file             = "main.tf"
    git_last_modified_at = "2021-07-22 23:46:37"
    git_last_modified_by = "manimahesh1@gmail.com"
    git_modifiers        = "manimahesh1"
    git_org              = "manimahesh"
    git_repo             = "udemy_terraform"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    "Name"               = "${var.env_prefix}-subnet-1"
    yor_trace            = "06140282-e314-4e30-97d8-47faf2428ba6"
    git_commit           = "0706f6549c75351646d3c3a856d0c476fa127593"
    git_file             = "main.tf"
    git_last_modified_at = "2021-07-22 22:49:58"
    git_last_modified_by = "manimahesh1@gmail.com"
    git_modifiers        = "manimahesh1"
    git_org              = "manimahesh"
    git_repo             = "udemy_terraform"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    "Name"               = "${var.env_prefix}-igw"
    yor_trace            = "05271025-889e-45ef-b8c3-53169812856e"
    git_commit           = "20736829c49a7a8d1b858c236e8a0bc26cbd600e"
    git_file             = "main.tf"
    git_last_modified_at = "2021-06-10 16:49:12"
    git_last_modified_by = "manimahesh1@gmail.com"
    git_modifiers        = "manimahesh1"
    git_org              = "manimahesh"
    git_repo             = "udemy_terraform"
  }
}

resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    "Name"               = "${var.env_prefix}-rtb"
    yor_trace            = "ccb91924-3066-43f6-a20a-2cf5f3c088b6"
    git_commit           = "20736829c49a7a8d1b858c236e8a0bc26cbd600e"
    git_file             = "main.tf"
    git_last_modified_at = "2021-06-10 16:49:12"
    git_last_modified_by = "manimahesh1@gmail.com"
    git_modifiers        = "manimahesh1"
    git_org              = "manimahesh"
    git_repo             = "udemy_terraform"
  }
}

resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}

resource "aws_security_group" "my-app-sg" {
  name   = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    "Name"               = "${var.env_prefix}-sg"
    yor_trace            = "b3ce211e-b2c1-444d-bdf4-5e0ae71ab8fd"
    git_commit           = "0706f6549c75351646d3c3a856d0c476fa127593"
    git_file             = "main.tf"
    git_last_modified_at = "2021-07-22 22:49:58"
    git_last_modified_by = "manimahesh1@gmail.com"
    git_modifiers        = "manimahesh1"
    git_org              = "manimahesh"
    git_repo             = "udemy_terraform"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name="virtualization-type"
    values = ["hvm"]
  }
}

output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}

output "ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip
}


resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  #public_key = var.mypub_key
  public_key = file(var.public_key_location)
  tags = {
    yor_trace            = "4d6a04d8-145a-4edf-bf60-ddcd4e54f4be"
    git_commit           = "582a8fbc619e193f61c54d7bd4cf2abeb17f94a1"
    git_file             = "main.tf"
    git_last_modified_at = "2021-07-22 23:34:14"
    git_last_modified_by = "manimahesh1@gmail.com"
    git_modifiers        = "manimahesh1"
    git_org              = "manimahesh"
    git_repo             = "udemy_terraform"
  }
}

resource "aws_instance" "myapp-server" {
  ami           = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id              = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_security_group.my-app-sg.id]
  availability_zone      = var.avail_zone

  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key.key_name

  user_data = file("entry-script.sh")

  tags = {
    "Name"               = "${var.env_prefix}-server"
    yor_trace            = "c52f1f0a-ac32-4e5c-8044-5f271da90dcb"
    git_commit           = "6bcb2a55d93e3bd8054281e3b7d3daf71ad698c5"
    git_file             = "main.tf"
    git_last_modified_at = "2021-07-22 23:46:37"
    git_last_modified_by = "manimahesh1@gmail.com"
    git_modifiers        = "manimahesh1"
    git_org              = "manimahesh"
    git_repo             = "udemy_terraform"
  }
  ebs_optimized = true
}
