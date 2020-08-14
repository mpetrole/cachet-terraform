# todo: add snapshots to database

resource "aws_db_subnet_group" "cachet" {
  name        = "cachet-sg"
  description = "RDS subnet group for cachet db instance"
  subnet_ids  = var.private_subnets
}

resource "aws_db_instance" "cachet" {

  identifier              = "cachet-db"
  allocated_storage       = var.db_storage_size
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = var.postgres_version
  instance_class          = var.db_instance_type
  db_subnet_group_name    = aws_db_subnet_group.cachet.id
  vpc_security_group_ids  = ["${aws_security_group.cachet_rds.id}"]
  username                = "postgres"
  password                = var.cachet_db_pass
  parameter_group_name    = "default.postgres9.6"
  skip_final_snapshot     = true
  backup_retention_period = var.backup_retention
  storage_encrypted       = true
  kms_key_id              = aws_kms_key.key.arn
}

resource "aws_security_group" "cachet_rds" {
  name        = "cachet-rds-postgres"
  description = "Allows the cachet instances to connect to the database"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
