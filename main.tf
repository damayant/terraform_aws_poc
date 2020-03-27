resource "aws_vpc" "test_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
      Name  = "test_vpc"
      Description = "demo"
  }
}

resource "aws_subnet" "public_subnet_1a" {
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = var.public_subnet_cidr_block
    availability_zone = "${var.region}${var.public_subnet_az}"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet_1b" {
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = var.private_subnet_cidr_block
    availability_zone = "${var.region}${var.private_subnet_az}"
    map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.test_vpc.id
    tags = {
        Name = "test_vpc_igw"
        Description = "demo"
    }
}

## NAT Gateway
resource "aws_eip" "nat_gw_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  subnet_id = aws_subnet.public_subnet_1a.id
  allocation_id = aws_eip.nat_gw_eip.id
}

## Public Route Table
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.test_vpc.id
    tags = {
        Name = "test_vpc public route table"
    }
}

resource "aws_route_table_association" "asc_public_subnet" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route" "connect_igw" {
    route_table_id = aws_route_table.public_rt.id
    gateway_id = aws_internet_gateway.igw.id
    destination_cidr_block = "0.0.0.0/0"
}

## Private Route Table
resource "aws_default_route_table" "private_rt" {
    default_route_table_id = aws_vpc.test_vpc.default_route_table_id
    route {
      nat_gateway_id = aws_nat_gateway.nat_gw.id
      cidr_block = "0.0.0.0/0"
    }

    tags = {
        Name = "test_vpc private route table"
    }
}

// resource "aws_route_table_association" "asc_private_subnet" {
//   route_table_id  = aws_route_table.private_rt.id
//   subnet_id = aws_subnet.private_subnet_1b.id
// }


## Security Group for instances in the public subnet
resource "aws_security_group" "allow_ssh_public" {
  name        = "allow_ssh"
  description = "Allow SSH traffic to public subnet"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.test_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_public"
  }
}

## Security Group for instances in the private subnet
resource "aws_security_group" "allow_ssh_icmp_private" {
  name        = "allow_ssh_private"
  description = "Allow SSH and ICMP traffic from public subnet"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    description = "SSH from instances in the public subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.allow_ssh_public.id]
  }

  ingress {
    description = "Ping from public subnet"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    security_groups = [aws_security_group.allow_ssh_public.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_icmp_private"
  }
}


# ssh-keygen -t rsa -b 4096 -C "shrobon@ualberta.ca" -f $HOME/.ssh/ec2
resource "aws_key_pair" "default" {
  key_name = var.public_key_name
  public_key = file("~/.ssh/ec2.pub")
}

resource "aws_instance" "public_instance" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name = aws_key_pair.default.id
  subnet_id = aws_subnet.public_subnet_1a.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_public.id]
  associate_public_ip_address = true
  source_dest_check = false

  tags = {
    Name = "Public-Instance"
    Describe = "Instance in public subnet"
  }
}

resource "aws_instance" "private_instance" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name = aws_key_pair.default.id
  subnet_id = aws_subnet.private_subnet_1b.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_icmp_private.id]
  associate_public_ip_address = false
  source_dest_check = false
  tags = {
    Name = "Private-Instance"
    Description = "Instance in private subnet"
  }
}