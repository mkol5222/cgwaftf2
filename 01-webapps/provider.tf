terraform {

    backend "http" {
  }
  required_providers {
    
    inext = {
      source  = "CheckPointSW/infinity-next"
      version = "1.0.3"
    }

  }
}

provider "inext" {
  region     = "eu"
  client_id  = var.POLICY_CLIENT_ID  // can be set with env var INEXT_CLIENT_ID
  access_key = var.POLICY_SECRET_KEY // can be set with env var INEXT_ACCESS_KEY
}
