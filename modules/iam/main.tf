data "aws_iam_policy" "s3_full_access_policy" {
  name = "AmazonS3FullAccess"
}

resource "aws_iam_role" "ec2_s3_fullAccess_role" {
  name = "s3FullAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    "terraform" = "yes"
    "Mode" = "common"
    "ManagedBy" = "Yudiz"
  }
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.ec2_s3_fullAccess_role.name
  policy_arn = data.aws_iam_policy.s3_full_access_policy.arn
}

resource "aws_iam_instance_profile" "iam_instance_profile_name" {
  name = "s3FullAccess"
  role = aws_iam_role.ec2_s3_fullAccess_role.name
  
}
