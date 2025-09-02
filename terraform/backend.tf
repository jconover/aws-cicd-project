terraform {
  backend "s3" {
    # Configure your backend here
    # bucket = "your-terraform-state-bucket"
    # key    = "cicd-pipeline/terraform.tfstate"
    # region = "us-east-1"
    # encrypt = true
    # dynamodb_table = "terraform-state-lock"
  }
}
