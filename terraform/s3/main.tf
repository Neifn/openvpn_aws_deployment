provider "aws" {
  region = "${var.region}"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "openvpn-terraform-deployment-${var.cluster_name}"
  
  versioning {
      enabled = true
  }

  lifecycle {
      prevent_destroy = true
  }
}
