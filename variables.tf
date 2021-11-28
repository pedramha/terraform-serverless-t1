variable "cidr_block" {
  type        = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type = list(any)
  default = [ "eu-central-1a", "eu-central" ]
}