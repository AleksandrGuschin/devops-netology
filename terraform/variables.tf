
locals {
  web_instance_type_map = {
    stage = "t2.micro"
    prod = "t2.micro"
  }
    web_instance_count_map = {
    stage = 1
    prod = 2
  }
}

variable "region" {
  description = "The region where to deploy this code."
  default     = "us-west-2"
}

variable "expiration_days" {
    description = "Number of days after which to expunge the objects"
    default     = "90"
}
