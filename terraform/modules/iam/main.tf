resource "aws_iam_role" "vpn_role" {
  name  = "${var.cluster_name}_vpn_role"

  assume_role_policy = <<EOF
{
   "Version" : "2012-10-17",
   "Statement": [ {
      "Effect": "Allow",
      "Principal": {
         "Service": [ "ec2.amazonaws.com" ]
      },
      "Action": [ "sts:AssumeRole" ]
   } ]
}
EOF

  tags = {
      Name = "${var.cluster_name}_vpn_role"
  }
}
resource "aws_iam_policy" "s3_and_eip_policy" {
  name        = "${var.cluster_name}_s3_and_eip_policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
        {
            "Sid": "AllowEIPAttachment",
            "Effect": "Allow",
            "Resource": [
                "*"
            ],
            "Action": [
                "ec2:AssociateAddress",
                "ec2:DisassociateAddress"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_role" {
  role       = "${aws_iam_role.vpn_role.name}"
  policy_arn = "${aws_iam_policy.s3_and_eip_policy.arn}"
}
resource "aws_iam_instance_profile" "iam_profile" {
  name  = "${var.cluster_name}_iam_profile"
  role  = "${aws_iam_role.vpn_role.name}"
}