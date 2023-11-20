provider "aws" {
  region     = "eu-central-1"
  access_key = "AKIAQMFGQIMQ3P57JUOX"
  secret_key = "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"

}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "test_vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_security_group" "my_sg" {
  name   = "HTTP"
  vpc_id = aws_vpc.my_vpc.id

  ingress  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "my_instance" {
  ami                    = "ami-04376654933b081a7"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  tags = {
    "Name" = "MyEC2Instance"

  }
}
