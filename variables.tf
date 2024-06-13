variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  default     = "t2.large"
}

variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
  default     = "ami-0f58b397bc5c1f2e8"
}

variable "security_group_ids" {
  description = "List of security group IDs to attach"
  type        = list(string)
  default     = ["sg-03cc6452ec347a54a"]
}

variable "key_name" {
  description = "The name of the key pair to use"
  type        = string
  default     = "ERIC-Robotics-PSIPL"
}

variable "private_key_path" {
  description = "Path to the private key file for SSH access"
  type        = string
  default     = "~/.ssh/id_rsa"
}