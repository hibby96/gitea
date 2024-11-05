
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.key.public_key_openssh
}

resource "aws_security_group" "web" {
  vpc_id      = data.aws_vpc.my_vpc.id
  name        = "Gitea Web Access"
  description = "Allows HTTP and Gitea access"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "TCP"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id = data.aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }

}

resource "aws_instance" "gitea" {
  ami                    = data.aws_ami.al2.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.my_public_subnet.id
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.web.id]
  associate_public_ip_address = true

user_data = <<HEREDOC
  #!/bin/bash
  sudo yum update -y
  sudo amazon-linux-extras install docker -y
  sudo service docker start
  sudo usermod -a -G docker ec2-user

  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
HEREDOC

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/ec2-user/gitea || echo 'mkdir failed'",
      "sudo cloud-init status --wait || echo 'cloud-init failed'"
    ]
  }

  provisioner "file" {
    source      = "docker-compose.yaml"
    destination = "/home/ec2-user/gitea/docker-compose.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ec2-user/gitea/",
      "/usr/local/bin/docker-compose up -d || echo 'docker compose failed'"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.key.private_key_pem
    host        = self.public_ip
  }
}

resource "aws_eip" "gitea_eip" {
  instance = aws_instance.gitea.id
  domain = "vpc"
}
