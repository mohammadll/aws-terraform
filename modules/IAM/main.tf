locals {
  create_iam_group                                          = var.create_iam_group
  create_iam_read_only_and_s3_full_access_policy            = var.create_iam_read_only_and_s3_full_access_policy
  create_iam_read_only_and_s3_full_access_policy_attachment = var.create_iam_read_only_and_s3_full_access_policy_attachment
  create_iam_users                                          = var.create_iam_users
  create_iam_ec2_get_console_screenshot_policy              = var.create_iam_ec2_get_console_screenshot_policy
  create_iam_ec2_get_console_screenshot_policy_attachment   = var.create_iam_ec2_get_console_screenshot_policy_attachment
  create_iam_user_group_membership                          = var.create_iam_user_group_membership
  create_iam_rule_with_policy                               = var.create_iam_rule_with_policy
}

resource "aws_iam_group" "developers_group" {
  count = local.create_iam_group ? 1 : 0
  name  = var.group_info["name"]
  path  = var.group_info["path"]
}

data "aws_iam_policy_document" "iam_read_only_and_s3_full_access" {

  dynamic "statement" {
    for_each = var.iam_read_only_and_s3_full_access
    content {
      actions   = statement.value["actions"]
      resources = statement.value["resources"]
      effect    = statement.value["effect"]
    }
  }
}

resource "aws_iam_policy" "iam_read_only_and_s3_full_access" {
  count       = local.create_iam_read_only_and_s3_full_access_policy ? 1 : 0
  name        = "iam_read_only_and_s3_full_access"
  path        = "/"
  description = "Read Only Access to IAM and Full Access to S3"
  policy      = data.aws_iam_policy_document.iam_read_only_and_s3_full_access.json
}

resource "aws_iam_group_policy_attachment" "group_policy_attachment" {
  count      = local.create_iam_group && local.create_iam_read_only_and_s3_full_access_policy && local.create_iam_read_only_and_s3_full_access_policy_attachment ? 1 : 0
  group      = aws_iam_group.developers_group[0].name
  policy_arn = aws_iam_policy.iam_read_only_and_s3_full_access[0].arn
}

resource "aws_iam_user" "users" {
  count = local.create_iam_users ? length(var.users) : 0
  name  = var.users[count.index]["name"]
  path  = var.users[count.index]["path"]

  tags = {
    user_created_by = "terraform"
  }
}

data "aws_iam_policy_document" "ec2_get_console_screenshot" {
  count = local.create_iam_ec2_get_console_screenshot_policy ? 1 : 0

  dynamic "statement" {
    for_each = var.ec2_get_console_screenshot
    content {
      actions   = statement.value["actions"]
      resources = statement.value["resources"]
      effect    = statement.value["effect"]
    }
  }
}

resource "aws_iam_policy" "ec2_get_console_screenshot" {
  count       = local.create_iam_ec2_get_console_screenshot_policy ? 1 : 0
  name        = "ec2_get_console_screenshot"
  path        = "/"
  description = "EC2 Get Console Screenshot"
  policy      = data.aws_iam_policy_document.ec2_get_console_screenshot[0].json
}

resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  count      = local.create_iam_users && local.create_iam_ec2_get_console_screenshot_policy && local.create_iam_ec2_get_console_screenshot_policy_attachment ? length(var.users) : 0
  user       = var.users[count.index]["name"]
  policy_arn = aws_iam_policy.ec2_get_console_screenshot[0].arn
}

resource "aws_iam_user_group_membership" "group_membership" {

  count = local.create_iam_users && local.create_iam_group && local.create_iam_user_group_membership ? length(var.users) : 0
  user  = var.users[count.index]["name"]

  groups = [
    aws_iam_group.developers_group[0].name,
  ]
}

data "aws_iam_policy_document" "instance_assume_role_policy" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "iam_read_only_access" {
  arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_role" "instance" {
  count               = local.create_iam_rule_with_policy ? 1 : 0
  name                = "instance_role"
  path                = "/"
  assume_role_policy  = data.aws_iam_policy_document.instance_assume_role_policy.json
  managed_policy_arns = [data.aws_iam_policy.iam_read_only_access.arn]
}
