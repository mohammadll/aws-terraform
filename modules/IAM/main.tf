resource "aws_iam_group" "developers_group" {
  name = var.group_info["name"]
  path = var.group_info["path"]
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
  name        = "iam_read_only_and_s3_full_access"
  path        = "/"
  description = "Read Only Access to IAM and Full Access to S3"
  policy      = data.aws_iam_policy_document.iam_read_only_and_s3_full_access.json
}

resource "aws_iam_group_policy_attachment" "group_policy_attachment" {
  group      = aws_iam_group.developers_group.name
  policy_arn = aws_iam_policy.iam_read_only_and_s3_full_access.arn
}

resource "aws_iam_user" "users" {
  for_each = var.users
  name     = each.value["name"]
  path     = each.value["path"]

  tags = {
    user_created_by = "terraform"
  }
}

data "aws_iam_policy_document" "ec2_get_console_screenshot" {

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
  name        = "ec2_get_console_screenshot"
  path        = "/"
  description = "EC2 Get Console Screenshot"
  policy      = data.aws_iam_policy_document.ec2_get_console_screenshot.json
}

resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  for_each   = aws_iam_user.users
  user       = each.value.name
  policy_arn = aws_iam_policy.ec2_get_console_screenshot.arn
}

resource "aws_iam_user_group_membership" "group_membership" {
  for_each = aws_iam_user.users
  user     = each.value.name

  groups = [
    aws_iam_group.developers_group.name,
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
  name                = "instance_role"
  path                = "/"
  assume_role_policy  = data.aws_iam_policy_document.instance_assume_role_policy.json
  managed_policy_arns = [data.aws_iam_policy.iam_read_only_access.arn]
}