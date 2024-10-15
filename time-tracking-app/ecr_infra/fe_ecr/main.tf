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

###########################################################################
###########################################################################

resource "aws_ecr_repository" "timethief-ecr-fe-1" {
  name      = "${var.github_org_name}_${var.github_repo_name}_fe_1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecr_lifecycle_policy" "ecr-lifecycle-policy-fe-1" {
  repository = aws_ecr_repository.timethief-ecr-fe-1.name
  policy     = templatefile(var.lifecycle_policy, {})
}


data "aws_iam_policy_document" "timethief-ecr-iam-document-fe-1" {
  statement {
    sid    ="${var.environment}-${var.project_name}-ecr-iam-policy-fe-1"
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

resource "aws_ecr_repository_policy" "timethief-ecr-iam-policy-fe-1" {
  repository = aws_ecr_repository.timethief-ecr-fe-1.name
  policy     = data.aws_iam_policy_document.timethief-ecr-iam-document-fe-1.json
}

output "ecr_repository_url_fe" {
  value = aws_ecr_repository.timethief-ecr-fe-1.repository_url
}
