terraform {
  backend "s3" {
    bucket         = "terraform-pdxfixit-us-west-1"
    dynamodb_table = "terraform-pdxfixit-us-west-1"
    encrypt        = true
    key            = "hostdb-datastore/terraform.tfstate"
    region         = "us-west-1"
    role_arn       = "arn:aws:iam::0123456789:role/provisioner"
    session_name   = "terraform@hostdb-datastore"
  }
}
