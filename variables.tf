variable "prefix" {
  default = "zs-terrafr"
}

variable "ssh_key_name" {
  default = "terrafr"
}


variable "ssh_private_key_path" {
  description = "Path to the SSH private key file"
  type        = string
  default     = "/Users/zackary/terrafr.pem"
}