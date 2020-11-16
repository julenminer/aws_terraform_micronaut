# Policy for EC2 Role
resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = aws_iam_role.ec2_role.id

  policy = <<-EOF
{
   "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": ["arn:aws:s3:::${var.bucket_name}"]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": ["arn:aws:s3:::${var.bucket_name}/*"]
        }
    ]
}
EOF
}

# EC2 Role
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_key_pair" "deployer_key" {
  key_name   = var.ec2_key_name
  public_key = var.ec2_public_key
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from outside"
    from_port   = 22
    to_port     = 22
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
    Name = "allow_ssh"
  }
}

resource "aws_instance" "ec2_sftp_server" {
  ami                         = "ami-0bb3fad3c0286ebd5"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Name = "s3fs-instance"
  }
  volume_tags = {
    Name = "s3fs-volume"
  }

  key_name = var.ec2_key_name

  security_groups = ["allow_ssh"]

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /tmp/init_scripts",
      "sudo chmod -R 777 /tmp/init_scripts"
    ]
    connection {
      host        = self.public_ip
      type        = "ssh"
      agent       = false
      private_key = file(var.ec2_private_key_file_path)
      user        = "ec2-user"
    }
  }

  provisioner "file" {
    source      = "init_scripts/"
    destination = "/tmp/init_scripts"
    connection {
      host        = self.public_ip
      type        = "ssh"
      agent       = false
      private_key = file(var.ec2_private_key_file_path)
      user        = "ec2-user"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh /tmp/init_scripts/configure.sh",
    ]
    connection {
      host        = self.public_ip
      type        = "ssh"
      agent       = false
      private_key = file(var.ec2_private_key_file_path)
      user        = "ec2-user"
    }
  }
}