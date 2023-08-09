provider "aws" {
  region = "ap-northeast-2"
}

# 최신 Amazon Linux 2 의 AMI 를 확인하여 EC2 를 생성
data "aws_ami" "amzn2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amzn2.id # 위의 data 값을 불러옵니다.
  instance_type = "t2.micro"
  #key_name      = "dev-tf-key"

  tags = {
    Name = "Terraform-ec2"
  }
}

resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow web inbound traffic"
  vpc_id      = "vpc-02dce66118c9d964e" # 사용하고자하는 VPC ID 입력

  ingress {
    description = "Web from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

resource "aws_instance" "example-2a" {
  ami           = data.aws_ami.amzn2.id # 위의 data 값을 불러옵니다.
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id = "subnet-0930aeab3d40bb472"
  availability_zone = "ap-northeast-2a"
  
  tags = {
    Name = "Terraform-ec2-2a"
  }
}

resource "aws_instance" "example-2c" {
  ami           = data.aws_ami.amzn2.id # 위의 data 값을 불러옵니다.
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id = "subnet-09f853d8362105a0d"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "Terraform-ec2-2c"
  }
}
