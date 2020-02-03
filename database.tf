resource "aws_db_instance" "kittens" {
  allocated_storage   = "${var.db_storage}"
  storage_type        = "${var.db_type}"
  engine              = "${var.db_engine}"
  instance_class      = "${var.db_instance}"
  name                = "kitten2"
  username            = "${var.db_username}"
  password            = "${var.postgres_pass}"
  port                = "${var.postgres_port}"
  publicly_accessible = "${var.true_value}"
  identifier          = "kitten-2"
  skip_final_snapshot = "${var.true_value}"
  tags = {
    Name = "kitten-db"
  }
}
