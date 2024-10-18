terraform {
  required_providers { 
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70.0"
    }
  }
  backend "s3" {
  }

}
data "aws_caller_identity" "current" {}

locals {
  account-id = data.aws_caller_identity.current.account_id
}

###########################################################################
###########################################################################

resource "aws_ecr_repository" "timethief-ecr-be-01" {
  name      = "${var.environment}-${var.project_name}-ecr-be-01"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}


resource "aws_ecr_lifecycle_policy" "timethief-ecr-lifecycle-policy-be-01" {
  repository = aws_ecr_repository.timethief-ecr-be-01.name
  policy     = <<EOF
{
    "rules": [
      {
        "rulePriority": 1,
        "description": "Keep last 2 images",
        "selection": {
          "tagStatus": "tagged",
          "tagPrefixList": [ "v" ],
          "countType": "imageCountMoreThan",
          "countNumber": 2
        },
        "action": {
          "type": "expire"
        }
      }
    ]
 }
EOF
}


data "aws_iam_policy_document" "timethief-ecr-iam-document-be-01" {
  statement {
    sid    ="${var.environment}-${var.project_name}-ecr-iam-policy-be-01"
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

resource "aws_ecr_repository_policy" "timethief-ecr-iam-policy-01" {
  repository = aws_ecr_repository.timethief-ecr-be-01.name
  policy     = data.aws_iam_policy_document.timethief-ecr-iam-document-be-01.json
}

output "ecr_repository_url_be" {
  value = aws_ecr_repository.timethief-ecr-be-01.repository_url
}
