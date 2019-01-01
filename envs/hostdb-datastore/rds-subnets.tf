//resource "aws_db_subnet_group" "hostdb_datastore_subnet_group_us_west" {
//  provider    = "aws.west"
//  name        = "hostdb_datastore_subnet_group"
//  description = "Group of subnets acceptable to house hostdb-server RDS instances"
//  subnet_ids  = [
//    "${var.us_west_1a_subnet_id}",
//    "${var.us_west_1c_subnet_id}"
//  ]
//
//  tags {
//    name = "hostdb-datastore"
//  }
//}

resource "aws_db_subnet_group" "hostdb_datastore_subnet_group_us_east" {
  description = "Group of subnets acceptable to house hostdb-server RDS instances"
  name        = "hostdb_datastore_subnet_group"
  provider    = "aws.east"

  subnet_ids = [
    "${var.us_east_1a_subnet_id}",
    "${var.us_east_1d_subnet_id}",
  ]

  tags {
    name = "hostdb-datastore"
  }
}
