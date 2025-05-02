resource "aws_iam_policy" "s3_policy" {
  name        = "ec2-s3-access-policy"
  description = "My test policy for ec2 to access s3"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [

          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::sruthilovesnarutouzumaki",
          "arn:aws:s3:::sruthilovesnarutouzumaki/*"

        ]
      },
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  name = "s3_policy_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "role_attach_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_attach" {
  name = "ec2_instance_s3_access"
  role = aws_iam_role.ec2_role.name
}

resource "aws_key_pair" "server" {
  key_name   = "terraform"
  public_key = file("C:/Users/bsrut/.ssh/id_ed25519.pub")
}

resource "aws_instance" "ec2_server" {
  ami                  = "ami-0f1dcc636b69a6438"
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.server.key_name
  security_groups      = ["default"]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_attach.name

  tags = {
    Name = "server-public"
  }
}

resource "null_resource" "set_upload" {
  depends_on = [aws_instance.ec2_server]

  provisioner "remote-exec" {
    inline = [

      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      # Ensure /var/www/html/ directory exists
      "sudo mkdir -p /var/www/html/",
      # Create a sample index.html file
      "echo '<h1>Welcome to My Web Server</h1>' | sudo tee /var/www/html/index.html",
      # Upload the file to S3
      "sudo yum install -y awscli",
      "aws s3 cp /var/www/html/index.html s3://sruthilovesnarutouzumaki/",
      "echo 'File uploaded to S3'"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/bsrut/.ssh/id_ed25519")
    host        = aws_instance.ec2_server.public_ip

  }

  triggers = {
    instance_id = aws_instance.ec2_server.id
  }

}

