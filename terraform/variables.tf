variable "region" {
  default = "us-east-1"
}

variable "key_name" {
  description = "The name of the existing AWS key pair"
  default     = "packer-key"
}

variable "my_ip" {
  description = "Your IP address in CIDR format"
  default     = "172.92.13.164/32" #
}

variable "custom_ami_id" {
  description = "The AMI ID created by Packer"
  default     = "ami-03bb0432716e2009f"
}
