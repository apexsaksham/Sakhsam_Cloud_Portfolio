variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}


variable "tags" {
  description = "A map of tags to assign to the bucket"
  type        = map(string)
  default     = {}
}

variable "upload_files" {
  description = "Whether to upload the static files"
  type        = bool
  default     = true
}

variable "cloudfront_oai_iam_arn" {
  description = "CloudFront OAI ARN to allow bucket policy access"
  type        = string
}