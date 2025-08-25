terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.9.0"
    }
  }
}

provider "aws" {
  # Configuration options
}



module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  tags = {
    Project = "frontend"
  }
  upload_files           = true
  cloudfront_oai_iam_arn = module.cloudfront.cloudfront_oai_iam_arn


}


module "cloudfront" {
  source                         = "./modules/cloudfront"
  s3_bucket_regional_domain_name = module.s3.s3_bucket_regional_domain_name
  acm_certificate_arn            = "arn:aws:acm:us-east-1:183295420353:certificate/42bb320f-63f4-4315-b486-392b5595e10a"

}