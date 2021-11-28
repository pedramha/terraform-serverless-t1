resource "aws_sfn_state_machine" "my_state_machine" {
  name = "my_state_machine"
  //arn:aws:lambda:eu-central-1:833915806704:function:HelloWorld
  role_arn = aws_iam_role.iam_for_step_function.arn
  definition = file("stepfunc.json.asl")
   tags = {
    "env" = "dev"
  }
}

resource "aws_iam_role" "iam_for_step_function" {
  name = "iam_for_step_function"
  assume_role_policy = file("stepfuncpolicy.json")
   tags = {
    "env" = "dev"
  }
  # jsonencode({
  #   "Version" : "2012-10-17",
  #   "Statement" : [{
  #     "Action" : "sts:AssumeRole",
  #     "Principal" : {
  #       "Service" : "states.amazonaws.com"
  #     },
  #     "Effect" : "Allow",
  #     "Sid" : ""
  #   }]
  # })
}