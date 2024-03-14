terraform {
  backend "s3" {
    #Bucket should be created in advance, Replace this with your bucket name!
    bucket         = "retailmass-predeployment-test"
    key            = "sagemaker/deployment/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}