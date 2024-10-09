terraform {
  required_providers { 
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70.0"
    }
  }
  backend "s3" {
    bucket = "terraformtimethiefresources"
    region = "eu-west-1"
  }

}
data "aws_caller_identity" "current" {}

locals {
  account-id = data.aws_caller_identity.current.account_id
}

resource "aws_ecr_repository" "timethief-ecr-1" {
  name      = "${var.environment}-${var.project_name}-ecr-1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "name" {
  repository = aws_ecr_repository.timethief-ecr-1.name
  policy     = templatefile(var.lifecycle_policy, {})
}

data "aws_iam_policy_document" "timethief-ecr-iam-document-1" {
  statement {
    sid    ="${var.environment}-${var.project_name}-ecr-iam-policy-1"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "timethief-ecr-iam-policy-1" {
  repository = aws_ecr_repository.timethief-ecr-1.name
  policy     = data.aws_iam_policy_document.timethief-ecr-iam-document-1.json
}

output "ecr_repository_url" {
  value = aws_ecr_repository.timethief-ecr-1.repository_url
}
