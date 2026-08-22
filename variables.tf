variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "The target AWS deployment region"
}

variable "my_home_ip" {
  type        = string
  default     = "192.168.64.2/32" # <-- REPLACE THIS with your actual public IP address
  description = "Your home IP address with a /32 mask for secure SSH access"
}
