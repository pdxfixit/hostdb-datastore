provider "aws" {
  region  = "us-west-1"
  version = "~> 1.0"

  assume_role {
    role_arn     = "arn:aws:iam::012345689:role/provisioner"
    session_name = "terraform@hostdb-datastore"
  }
}

provider "aws" {
  alias   = "west"
  region  = "us-west-1"
  version = "~> 1.0"

  assume_role {
    role_arn     = "arn:aws:iam::012345689:role/provisioner"
    session_name = "terraform@hostdb-datastore"
  }
}

provider "aws" {
  alias   = "east"
  region  = "us-east-1"
  version = "~> 1.0"

  assume_role {
    role_arn     = "arn:aws:iam::012345689:role/provisioner"
    session_name = "terraform@hostdb-datastore"
  }
}
