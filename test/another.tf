resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name"               = "${var.env_prefix}-vpc"
    yor_trace            = "68a2cee4-4283-44a6-962b-a48177b8abf2"
    git_commit           = "6bcb2a55d93e3bd8054281e3b7d3daf71ad698c5"
    git_file             = "main.tf"
    git_last_modified_at = "2021-07-22 23:46:37"
    git_last_modified_by = "manimahesh1@gmail.com"
    git_modifiers        = "manimahesh1"
    git_org              = "manimahesh"
    git_repo             = "udemy_terraform"
  }
}