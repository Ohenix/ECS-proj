#  securitygroups to protect applications

resource "aws_security_group" "SG_LB" {
  name        = "Sec_Group_for_LB"
  description = "firewall inbound traffic"
  vpc_id      = aws_vpc.Prod_Vpc.id



  ingress {

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {

    from_port   = 443
    to_port     = 443
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
    Name = "allow_tls"
  }
}


# Security Group for ECS

resource "aws_security_group" "SG-ECS" {
  name        = "Sec_Group_for_ECS"
  description = "inbound traffic from ALB"
  vpc_id      = aws_vpc.Prod_Vpc.id



  ingress {

    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.SG_LB.id]

  }

  ingress {

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

}


# security group for RDS MYSQL

resource "aws_security_group" "SG-RDS-MYSQL" {
  name        = "Sec_Group_for_MYSQL"
  description = "inbound traffic from ECS only"
  vpc_id      = aws_vpc.Prod_Vpc.id



  ingress {

    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.SG-ECS.id]

  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}





