# Define Local Values in Terraform
locals {
  environment = var.environment
  name = "food-ordering-${var.environment}"
  common_tags = {
    environment = local.environment
  }
} 