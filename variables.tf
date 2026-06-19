variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region to deploy resources"
}

variable "bucket_prefix" {
  type        = string
  default     = "macie-sensitive-scan"
  description = "Prefix for the S3 bucket name"
}

variable "alert_email" {
  type        = string
  description = "Email address to receive Macie finding alerts"
}
