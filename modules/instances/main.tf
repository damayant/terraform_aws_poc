# ssh-keygen -ef path_to_private_key -m PEM | openssl rsa -RSAPublicKey_in -outform DER | openssl md5 -c


resource "aws_key_pair" "keypair" {
  key_name   = "${var.public_key_name }${var.public_subnet_id}"
  public_key = file("~/.ssh/terraform.pub")
}

resource "aws_instance" "public_instance" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  key_name                    = "${var.public_key_name }${var.public_subnet_id}"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.public_sg]
  associate_public_ip_address = true
  source_dest_check           = false

  tags = {
    Name     = "Public-Instance"
    Describe = "Instance in public subnet"
  }
}

resource "aws_instance" "private_instance" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  key_name                    = "${var.public_key_name }${var.public_subnet_id}"
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.private_sg]
  associate_public_ip_address = false
  source_dest_check           = false
  tags = {
    Name        = "Private-Instance"
    Description = "Instance in private subnet"
  }
}