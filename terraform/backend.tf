terraform {
  backend "s3" {
    key            = "terraform.tfstate"
    use_path_style = true # for Localstack
  }
}
