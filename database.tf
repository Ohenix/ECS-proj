# my spql databse set up


resource "aws_db_instance" "Prod_rds" {
  allocated_storage      = "10"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "RDS_for_prod"
  username               = "verified"
  password               = "perseverance"
  parameter_group_name   = "default.mysql5.7"
  port                   = "3306"
  publicly_accessible    = false
  storage_encrypted      = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.SG-RDS-MYSQL.id]
  db_subnet_group_name   = aws_db_subnet_group.Prod_subnet_GP.name
}

# DB subnet Group

resource "aws_db_subnet_group" "Prod_subnet_GP" {
  name       = "subnet-group"
  subnet_ids = [aws_subnet.Prod_private_subnet1.id, aws_subnet.Prod_private_subnet2.id]

  tags = {
    Name = "Prod_subnet_GP"
  }
}