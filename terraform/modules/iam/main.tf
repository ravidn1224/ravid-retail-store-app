variable "project_name" {
  type = string
}

# EC2 

resource "aws_iam_role" "ec2_role" {
  name               = "${var.project_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
       type = "Service" 
       identifiers = ["ec2.amazonaws.com"] 
       }
  }
}

data "aws_iam_policy_document" "ecr_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecr_access" {
  name   = "${var.project_name}-ecr-access"
  policy = data.aws_iam_policy_document.ecr_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_ecr" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ecr_access.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

output "instance_profile_name" { value = aws_iam_instance_profile.ec2_profile.name }

# IAM user with ecr role

resource "aws_iam_user" "ecr_user" {
  name = "${var.project_name}-ecr-user"
}

data "aws_iam_policy_document" "user_assume_role_trust" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.ecr_user.arn]
    }
  }
}

resource "aws_iam_role" "ecr_user_role" {
  name               = "${var.project_name}-ecr-user-role"
  assume_role_policy = data.aws_iam_policy_document.user_assume_role_trust.json
}

resource "aws_iam_role_policy_attachment" "ecr_user_role_attachment" {
  role       = aws_iam_role.ecr_user_role.name
  policy_arn = aws_iam_policy.ecr_access.arn
}

output "ecr_user_name" {
  value = aws_iam_user.ecr_user.name
}

output "ecr_user_role_arn" {
  value = aws_iam_role.ecr_user_role.arn
}