locals {
  assets       = yamldecode(file("${path.module}/../01-webapps/spec/assets.yaml"))
  domain_names = [for webapp in local.assets : webapp.name]
}

output "assets" {
  value = local.assets
}

output "domain_names" {
  value = local.domain_names
}