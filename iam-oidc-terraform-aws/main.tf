provider "aws" {
  profile = ""
  region  = ""
}

locals {
  environment = "prd"
}

data "aws_eks_cluster" "this" {
  name = ""
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "s3-loki" {
  source = "./modules/s3"

  name_bucket = "eks-lgtm-loki"
  environment = local.environment
}

module "s3-tempo" {
  source = "./modules/s3"

  name_bucket = "eks-lgtm-tempo"
  environment = local.environment
}

module "s3-mimir" {
  source = "./modules/s3"

  name_bucket = "eks-lgtm-mimir"
  environment = local.environment
}

module "s3-mimir-ruler" {
  source = "./modules/s3"

  name_bucket = "eks-lgtm-mimir-ruler-bucket"
  environment = local.environment
}

module "iam-loki" {
  source = "./modules/iam"

  iam_roles = {
    "loki-${local.environment}" = {
      "openid_connect" = "${data.aws_iam_openid_connect_provider.this.arn}"
      "openid_url"     = "${data.aws_iam_openid_connect_provider.this.url}"
      "serviceaccount" = "loki"
      "string"         = "StringEquals"
      "namespace"      = "lgtm"
      "policy"         = local.policy_arn_loki
    }
  }

}


module "iam-tempo" {
  source = "./modules/iam"

  iam_roles = {
    "tempo-${local.environment}" = {
      "openid_connect" = "${data.aws_iam_openid_connect_provider.this.arn}"
      "openid_url"     = "${data.aws_iam_openid_connect_provider.this.url}"
      "serviceaccount" = "tempo"
      "string"         = "StringEquals"
      "namespace"      = "lgtm"
      "policy"         = local.policy_arn_tempo
    }
  }

}

module "iam-mimir" {
  source = "./modules/iam"

  iam_roles = {
    "mimir-${local.environment}" = {
      "openid_connect" = "${data.aws_iam_openid_connect_provider.this.arn}"
      "openid_url"     = "${data.aws_iam_openid_connect_provider.this.url}"
      "serviceaccount" = "mimir"
      "string"         = "StringEquals"
      "namespace"      = "lgtm"
      "policy"         = local.policy_arn_mimir
    }
  }
}

