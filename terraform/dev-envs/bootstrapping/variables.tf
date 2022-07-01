variable "profile" {
  description = "Please enter the name of the AWS credential profile you want to use"
}

variable "region" {
  default = "eu-west-2"
}

variable "environment_name" {
  description = "Enter prefix for all bootstrapping files"

}

variable "key" {
  default = "terraform-state"
}
