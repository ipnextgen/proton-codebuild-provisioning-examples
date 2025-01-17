terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      "proton:service"  = var.service.name,
      "proton:pipeline" = var.service.name
    }
  }
}

module "cicd_pipeline" {
  source = "./src"

  # name based on proton input
  name = var.service.name

  # service input
  service_name              = var.service.name
  repository_connection_arn = var.service.repository_connection_arn
  repository_id             = var.service.repository_id
  branch_name               = var.service.branch_name

  # service instances
  service_instances = var.service_instances

  # pipeline input
  service_source_dir = var.pipeline.inputs.service_dir
  dockerfile         = var.pipeline.inputs.dockerfile
  unit_test_command  = var.pipeline.inputs.unit_test_command
}
