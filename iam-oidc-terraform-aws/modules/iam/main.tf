data "aws_iam_policy_document" "example_assume_role_policy" {
  for_each = var.iam_roles

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = each.value.string
      variable = "${replace("${each.value.openid_url}", "https://", "")}:sub"
      values   = ["system:serviceaccount:${each.value.namespace}:${each.value.serviceaccount}"]
    }

    condition {
      test     = each.value.string
      variable = "${replace("${each.value.openid_url}", "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [each.value.openid_connect]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "this" {
  for_each = var.iam_roles

  assume_role_policy = data.aws_iam_policy_document.example_assume_role_policy[each.key].json
  name               = each.key
}

resource "aws_iam_role_policy" "this" {
  for_each = var.iam_roles

  name = each.key
  role = aws_iam_role.this[each.key].id

  policy = each.value.policy

}
