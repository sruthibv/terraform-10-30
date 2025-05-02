resource "aws_key_pair" "server" {
  key_name   = "terraform"
  public_key = file("C:/Users/bsrut/.ssh/id_ed25519.pub") 
}

resource "aws_instance" "server" {
  ami                    = "ami-0f1dcc636b69a6438"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.server.key_name    

provisioner "file" {
  source = "file1"
  destination = "/home/ec2-user/file1"
}

connection {
  type = "ssh"
  user = "ec2-user"
  private_key = file("C:/Users/bsrut/.ssh/id_ed25519")
  host = self.public_ip
}

provisioner "remote-exec" {
  inline = [ 
        
        "sudo yum install nginx -y",
        "sudo systemctl start nginx",
        "sudo systemctl enable nginx"
   ]
}
}