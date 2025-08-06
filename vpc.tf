#vpc
resource "aws_vpc" "vpc-1" {
  cidr_block = "10.0.0.0/16"
   
  tags = {
    Name = "${var.client_name}-vpc"
    managed_by = "${var.managed_by}"
  }
}
#internet gateway.
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc-1.id
   
  tags = {
    Name = "${var.client_name}-igw1"
    managed_by = "${var.managed_by}"
  }
}
#public subnet 1 
resource "aws_subnet" "pub_subnet1" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.0.1.0/24"
    
    tags = {
    Name = "${var.client_name}-pub_subnet1"
    managed_by = "${var.managed_by}"
  }
}
#private subnet 2
resource "aws_subnet" "pir_subnet2" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.0.2.0/24"
    
    tags = {
    Name = "${var.client_name}-pir_subnet2"
    managed_by = "${var.managed_by}"
  }
}
#public RT 1
resource "aws_route_table" "pub_rt1" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }

  tags = {
  Name = "${var.client_name}-pub_rt1"
  managed_by = "${var.managed_by}"
  }
}
#private RT 2
resource "aws_route_table" "pir_rt2" {
  vpc_id = aws_vpc.vpc-1.id

  tags = {
  Name = "${var.client_name}-pir_rt2"
  managed_by = "${var.managed_by}"
  }
}
#public subnet 1 association
resource "aws_route_table_association" "pubsub1_rt1" {
  subnet_id      = aws_subnet.pub_subnet1.id
  route_table_id = aws_route_table.pub_rt1.id
}
#private subnet 2 association
resource "aws_route_table_association" "pirsub_rt2" {
  subnet_id      = aws_subnet.pir_subnet2.id
  route_table_id = aws_route_table.pir_rt2.id
}
#Security group 1
resource "aws_security_group" "sg1" {
  name        ="${var.client_name}-sg1"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc-1.id

   ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  
  }
   egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  tags = {
  Name = "${var.client_name}-sg12"
  managed_by = "${var.managed_by}"
  }
}
#ec2 - web1
resource "aws_instance" "web" {
  ami           = "ami-0c9fb5d338f1eec43"
  instance_type = var.my-instance-type
  subnet_id = "subnet-0f701e0fec551032e"
  key_name = "adam-n.virginia"
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["sg-06218909358b6da67"]

  tags = {
  Name = "${var.client_name}-web1"
  managed_by = "${var.managed_by}"
  }

}
#ec2 - DB1
resource "aws_instance" "db1" {
  ami           = "ami-0c9fb5d338f1eec43"
  instance_type = var.my-instance-type
  subnet_id = "subnet-0f701e0fec551032e"
  key_name = "adam-n.virginia"
  vpc_security_group_ids = ["sg-06218909358b6da67"]

  tags = {
  Name = "${var.client_name}-DB1"
  managed_by = "${var.managed_by}"
  }
}

output "my_web1_public_ip" {
  value = aws_instance.web.public_ip
  
}

output "my_web1_private_ip" {
  value = aws_instance.web.private_ip
  
}
output "my_dp1_private_ip" {
  value = aws_instance.web.private_ip
  
}