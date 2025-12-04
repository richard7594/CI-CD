# Définition du provider AWS
provider "aws" {
  region = "eu-north-1" # Spécifier la région AWS souhaitée
}

# Définition du VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main_vpc"
  }
}

# Subnet public
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

# Subnet privé
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-north-1a"
  tags = {
    Name = "private_subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main_igw"
  }
}

# Route Table pour le subnet public
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public_route_table"
  }
}

# Association de la route pour le subnet public
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Security Group pour EC2 (Web Server)
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Limitez l'accès SSH à votre IP
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2_sg"
  }
}

# Security Group pour RDS (Base de données MySQL)
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port = 3306 # Port par défaut MySQL
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Permet l'accès depuis le VPC
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "rds_sg"
  }
}

# EC2 Web Server (instance t2.micro)
resource "aws_instance" "web_server" {
  ami = "ami-0744568de95a42bd6"  # Remplacez ceci par l'ID de l'AMI valide pour eu-north-1
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name = "web-server"
  tags = {
    Name = "web_server"
  }
}


resource "aws_eip" "web_server_eip" {
  instance = aws_instance.web_server.id
    # Important si l'instance est dans un VPC
}




# Sous-réseau privé 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-north-1a"
  tags = {
    Name = "private_subnet_1"
  }
}

# Sous-réseau privé 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-north-1b"  # Autre zone de disponibilité
  tags = {
    Name = "private_subnet_2"
  }
}

# Définition du groupe de sous-réseaux pour RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds_subnet_group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  tags = {
    Name = "rds_subnet_group"
  }
}

# Instance RDS MySQL (db.t2.micro)
resource "aws_db_instance" "rds_instance" {
  allocated_storage = 20
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro" # Utilisation de la plus petite instance pour RDS
  db_name = "mydatabase"
  username = "admin"
  password = "strong_password_here"  # Utilisez un mot de passe sécurisé
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot = false  # Configurez cette option selon vos besoins (false pour créer un snapshot final)
  final_snapshot_identifier = "mydatabase-final-snapshot"  # Identifier pour le snapshot final
  tags = {
    Name = "rds_instance"
  }
}

