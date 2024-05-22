# list of domain names and domain ownershoip validation CNAMEs

data "http" "domains" {
  url    = "https://cloudinfra-gw.portal.checkpoint.com/app/waf/graphql"
  method = "POST"
  request_headers = {
    "authorization" = "Bearer ${local.token_appsec}"
    "content-type"  = "application/json"
  }
  request_body = <<EOT
{   "variables": { "id": "${var.profile_id}" },
    "query":"query Profile($id: ID!) { getProfile(id: $id) { id name profileType ... on AppSecSaaSProfile { certificatesDomains { id domain cnameName cnameValue certificateValidationStatus } } } }"
}
EOT
}

locals {
  domains = jsondecode(data.http.domains.response_body)
}

output "domains" {
  value = local.domains.data.getProfile.certificatesDomains
}

resource "cloudflare_record" "validation" {

  for_each = { for domain in jsondecode(data.http.domains.response_body).data.getProfile.certificatesDomains :
    domain.domain => domain
    if contains(local.domain_names, domain.domain)
  }

  zone_id = var.CLOUDFLARE_DNS_ZONEID
  name    = each.value.cnameName
  value   = each.value.cnameValue
  type    = "CNAME"
  ttl     = 3600
}

locals {
  validating_domains =  [ for cname in cloudflare_record.validation : cname.name ]
  valid_domains = [ for domain in jsondecode(data.http.domains.response_body).data.getProfile.certificatesDomains :
     domain.domain
    if contains(local.domain_names, domain.domain) && domain.certificateValidationStatus == "SUCCESS"
  ]
}

output "valid_domains" {
  value = local.valid_domains
}

output "validating_domains" {
  value = local.validating_domains
}