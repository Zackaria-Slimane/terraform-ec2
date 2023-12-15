variable "prefix" {
  default = "zs-terraform"
}

variable "ssh_key_name" {
  default = "terraform"
}


variable "ssh_private_key_path" {
  description = "Path to the SSH private key file"
  type        = string
  default     = "/Users/zackary/terraform.pem"
}