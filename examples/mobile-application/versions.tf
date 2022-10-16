terraform {
  required_version = ">= 1.1"

  required_providers {
    pingone = {
      source  = "pingidentity/pingone"
      version = ">= 0.6.1"
    }
  }
}