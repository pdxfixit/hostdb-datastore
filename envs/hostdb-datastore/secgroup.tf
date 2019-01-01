//resource "aws_security_group" "hostdb_datastore_sg_us_west" {
//  description = "Allow inbound traffic on 3306"
//  name        = "hostdb-datastore"
//  provider    = "aws.west"
//  vpc_id      = "${var.us_west_vpc_id}"
//
//  ingress {
//    cidr_blocks = [
//      "10.10.0.0/18"
//    ]
//    from_port   = 3306
//    protocol    = "TCP"
//    to_port     = 3306
//  }
//
//  egress {
//    cidr_blocks = [
//      "0.0.0.0/0"
//    ]
//    from_port   = 0
//    protocol    = "-1"
//    to_port     = 0
//  }
//
//  tags {
//    name = "hostdb-datastore"
//  }
//}

resource "aws_security_group" "hostdb_datastore_sg_us_east" {
  description = "Allow inbound traffic on 3306"
  name        = "hostdb-datastore"
  provider    = "aws.east"
  vpc_id      = "${var.us_east_vpc_id}"

  ingress {
    cidr_blocks = [
      "10.20.0.0/16",
      "10.50.0.0/16",
    ]

    from_port = 3306
    protocol  = "TCP"
    to_port   = 3306
  }

  egress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]

    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }

  tags {
    name = "hostdb-datastore"
  }
}
