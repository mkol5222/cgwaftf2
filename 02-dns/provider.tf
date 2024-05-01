terraform {
    backend "http" {
  }
  
  required_providers {

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.30.0"
    }
  }
}


provider "cloudflare" {
  # Configuration options
  api_token = var.CLOUDFLARE_DNS_API_TOKEN
}