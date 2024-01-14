variable "prefix" {
  default = "zs-portfolio"
}

variable "ssh_key_name" {
  default = "zsfolio"
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key file"
  type        = string
  default     = "/Users/zackary/zsfolio.pem"
}
