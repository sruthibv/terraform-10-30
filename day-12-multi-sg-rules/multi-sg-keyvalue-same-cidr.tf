variable "ports" {
  type = map(string)
  default = {
    22    = "192.0.0.0/20"    
    80    = "0.0.0.0/0"         
    443   = "0.0.0.0/0"        
    8080  = "10.0.0.0/16"       
  
  }
}

resource "aws_security_group" "keys_sg" {
  name        = "keys-sg"
  description = "Allow restricted inbound traffic"

  dynamic "ingress" {
    for_each = var.ports
    content {
      description = "Allow access to port ${ingress.key}"
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "keys-sg"
  }
}
