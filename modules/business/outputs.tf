
# //output the api gateways url
output "stepfunc_arn" {
  description = "step funcitons arn"
  value = aws_sfn_state_machine.my_state_machine.arn
}