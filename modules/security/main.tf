# modules/security/main.tf
resource "aws_guardduty_detector" "this" {
  enable = true
}

resource "aws_iam_policy" "read_only" {
  name        = "${var.env}-read-only"
  description = "Read-only access policy"
  policy      = data.aws_iam_policy_document.read_only.json
}

data "aws_iam_policy_document" "read_only" {
  statement {
    actions   = ["ec2:Describe*", "s3:Get*"]
    resources = ["*"]
  }
}
