resource "aws_sfn_state_machine" "my_state_machine" {
  name       = "my_state_machine"
  role_arn   = aws_iam_role.iam_for_step_function.arn
  definition = file("${path.module}/stepfunc.json.asl")
  tags = {
    "owner" = "pedram@hashicorp.com"
    "env"   = "dev"
  }
}

resource "aws_iam_role" "iam_for_step_function" {
  name               = "iam_for_step_function"
  assume_role_policy = file("${path.module}/stepfuncpolicy.json")
  tags = {
    "owner" = "pedram@hashicorp.com"
    "env"   = "dev"
  }
}