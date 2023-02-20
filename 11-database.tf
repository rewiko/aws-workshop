resource "random_password" "master" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "password" {
  name = "workshop-v7-db-password"
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.password.id
  secret_string = random_password.master.result
}

resource "aws_secretsmanager_secret" "db_hostname" {
  name = "workshop-v7-db-hostname"
}

resource "aws_secretsmanager_secret_version" "db_hostname" {
  secret_id     = aws_secretsmanager_secret.db_hostname.id
  secret_string = aws_db_instance.db.address
}

resource "aws_db_instance" "db" {
  allocated_storage    = 10
  name                 = "workshopdb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "dbadmin"
  password             = aws_secretsmanager_secret_version.password.secret_string
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.rds_mysql.name
  vpc_security_group_ids = [
    "${aws_security_group.rds_mysql.id}",
  ]

}

resource "aws_db_subnet_group" "rds_mysql" {
  name        = "${var.environment}-rds-mysql-subnet-group"
  description = "RDS database subnet group"

  subnet_ids = aws_subnet.pub-subnets.*.id

  tags = {
    Name        = "${var.environment}:rds_mysql"
    Environment = var.environment
  }
}

resource "aws_security_group" "rds_mysql" {
  description = "RDS security group"
  name        = "${var.environment}:rds_mysql"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}:rds_mysql"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "rds_mysql" {
  security_group_id = aws_security_group.rds_mysql.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306

  cidr_blocks = var.subnets-ips
}
