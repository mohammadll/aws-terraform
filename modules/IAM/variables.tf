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
  type = map(map(string))
  default = {
    user_jack = {
      name = "jack"
      path = "/"
    },
    user_jones = {
      name = "jones"
      path = "/"
    }
  }
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