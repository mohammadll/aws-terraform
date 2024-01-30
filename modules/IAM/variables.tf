variable "create_iam_group" {
  type    = bool
  default = true
}

variable "create_iam_read_only_and_s3_full_access_policy" {
  type    = bool
  default = true
}

variable "create_iam_read_only_and_s3_full_access_policy_attachment" {
  type    = bool
  default = true
}

variable "create_iam_users" {
  type    = bool
  default = true
}

variable "create_iam_ec2_get_console_screenshot_policy" {
  type    = bool
  default = true
}

variable "create_iam_ec2_get_console_screenshot_policy_attachment" {
  type    = bool
  default = true
}

variable "create_iam_user_group_membership" {
  type    = bool
  default = true
}

variable "create_iam_rule_with_policy" {
  type    = bool
  default = true
}

variable "group_info" {
  type = map(string)
  default = {
    name = "developers"
    path = "/"
  }
}

variable "iam_read_only_and_s3_full_access" {
  type = map(object({
    actions   = list(string)
    resources = list(string)
    effect    = string
  }))
  default = {
    iam_read_only = {
      actions = [
        "iam:Get*",
        "iam:List*"
      ]
      resources = ["*"]
      effect    = "Allow"
    },
    s3_full_access = {
      actions = [
        "s3:*"
      ]
      resources = ["*"]
      effect    = "Allow"
    }
  }
}

variable "users" {
  type = list(map(string))
  default = [
    {
      name = "jack"
      path = "/"
    },
    {
      name = "jones"
      path = "/"
    }
  ]
}

variable "ec2_get_console_screenshot" {
  type = map(object({
    actions   = list(string)
    resources = list(string)
    effect    = string
  }))
  default = {
    ec2_get_console_screenshot = {
      actions = [
        "ec2:GetConsoleScreenshot"
      ]
      resources = ["*"]
      effect    = "Allow"
    }
  }
}
