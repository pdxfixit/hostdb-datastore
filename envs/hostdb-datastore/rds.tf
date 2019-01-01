variable "hostdb_datastore_username" {
  default = "app"
  type    = "string"
}

variable "hostdb_datastore_password" {
  default = "badpassword"
  type    = "string"
}

//resource "aws_db_instance" "hostdb_datastore_us_west" {
//  allocated_storage          = "5"
//  auto_minor_version_upgrade = true
//  backup_retention_period    = "5"
//  db_subnet_group_name       = "${aws_db_subnet_group.hostdb_datastore_subnet_group_us_west.id}"
//
//  depends_on = [
//    "aws_security_group.hostdb_datastore_sg_us_west",
//    "aws_db_subnet_group.hostdb_datastore_subnet_group_us_west",
//  ]
//
//  engine                    = "mariadb"
//  engine_version            = "10.3"
//  final_snapshot_identifier = "hostdb-final"
//  identifier                = "hostdb-datastore"
//  instance_class            = "db.m5.large"
//  multi_az                  = true
//  name                      = "hostdb"
//  password                  = "${var.hostdb_datastore_password}"
//  provider                  = "aws.west"
//  skip_final_snapshot       = false
//  username                  = "${var.hostdb_datastore_username}"
//
//  vpc_security_group_ids = [
//    "${aws_security_group.hostdb_datastore_sg_us_west.id}",
//  ]
//
//  tags {
//    name = "hostdb-datastore"
//  }
//}

resource "aws_db_instance" "hostdb_datastore_us_east" {
  allocated_storage          = "10"
  auto_minor_version_upgrade = true
  backup_retention_period    = "5"
  db_subnet_group_name       = "${aws_db_subnet_group.hostdb_datastore_subnet_group_us_east.id}"

  depends_on = [
    "aws_security_group.hostdb_datastore_sg_us_east",
    "aws_db_subnet_group.hostdb_datastore_subnet_group_us_east",
  ]

  engine                    = "mariadb"
  engine_version            = "10.3"
  final_snapshot_identifier = "hostdb-final"
  identifier                = "hostdb-datastore"
  instance_class            = "db.m5.large"
  multi_az                  = true
  name                      = "hostdb"
  password                  = "${var.hostdb_datastore_password}"
  provider                  = "aws.east"
  skip_final_snapshot       = false
  username                  = "${var.hostdb_datastore_username}"

  vpc_security_group_ids = [
    "${aws_security_group.hostdb_datastore_sg_us_east.id}",
  ]

  tags {
    name = "hostdb-datastore"
  }
}
