variable "cidr_block" {
  type        = string
}

variable "availability_zones" {
  type = list(any)
  default = [ "eu-central-1a", "eu-central" ]
}