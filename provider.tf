# provider.tf: Configure the AWS provider.

provider "aws" {
  region = var.region
}
