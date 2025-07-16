# modules/database/main.tf
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string }
variable "db_instance_class" { type = string }

resource "aws_db_instance" "this" {
  identifier         = var.db_name
  engine             = "postgres"
  instance_class     = var.db_instance_class
  username           = var.db_username
  password           = var.db_password
  allocated_storage  = 20
  skip_final_snapshot = true
}
