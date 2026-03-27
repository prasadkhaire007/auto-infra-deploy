terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.38.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "example" {
  ami           = "ami-05d2d839d4f73aafb"
  instance_type = "t3.micro"

  tags = {
    Name = "Auto-Deployed-Instance"
  }
}
