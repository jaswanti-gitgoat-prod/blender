# Sample Terraform configuration file with potential security risks

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "insecure_instance" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  # 1. Security Group with overly permissive rules
  security_groups = ["${aws_security_group.allow_all.name}"]

  tags = {
    Name = "insecure-instance"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Security group with overly permissive rules"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # 2. Open to the world, allows any traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "my-insecure-bucket"

  # 3. S3 bucket with public access
  acl    = "public-read"  # Public read access, may expose sensitive data

  versioning {
    enabled = true
  }

  tags = {
    Name = "insecure-bucket"
  }
}

resource "aws_db_instance" "insecure_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "supersecretpassword"  # 4. Hardcoded database password
  parameter_group_name = "default.mysql5.7"

  # 5. No encryption at rest
  storage_encrypted = false  # Data is not encrypted at rest

  # 6. Publicly accessible database
  publicly_accessible = true  # Exposes database to the public internet
}

resource "aws_iam_policy" "insecure_policy" {
  name        = "insecure-policy"
  description = "IAM policy with full access"

  # 7. Overly permissive IAM policy
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
