# domains to protection CNAMEs
# IN: local.domain_names, var.profile_id, local.token_appsec

# CHANGES:
# use local.valid_domains to get the domain names instead of local.domain_names

data "http" "protection_cname" {

  url        = "https://cloudinfra-gw.portal.checkpoint.com/app/waf/graphql"
  method     = "POST"
  request_headers = {
    "authorization" = "Bearer ${local.token_appsec}"
    "content-type"  = "application/json"
  }
  request_body = <<EOT
{"operationName":"PublicCNAME","variables":{"region":"eu-west-1","domains":${jsonencode(local.valid_domains)},"profileId":"${var.profile_id}"},"query":"query PublicCNAME($region: String, $domains: [String], $profileId: String) {\n  getPublicCNAME(region: $region, domains: $domains, profileId: $profileId) {\n    domain\n    cname\n    __typename\n  }\n}\n"}
EOT
}

data "http" "debug_protection_cname" {
  for_each = { for domain in local.valid_domains : 
    domain => domain
  }

  url        = "https://cloudinfra-gw.portal.checkpoint.com/app/waf/graphql"
  method     = "POST"
  request_headers = {
    "authorization" = "Bearer ${local.token_appsec}"
    "content-type"  = "application/json"
  }
  request_body = <<EOT
{"operationName":"PublicCNAME","variables":{"region":"eu-west-1","domains":["${each.key}"],"profileId":"${var.profile_id}"},"query":"query PublicCNAME($region: String, $domains: [String], $profileId: String) {\n  getPublicCNAME(region: $region, domains: $domains, profileId: $profileId) {\n    domain\n    cname\n    __typename\n  }\n}\n"}
EOT
}


output "debug_protection_cname_onebyone" {
  value = { for domain in local.valid_domains : 
    domain => jsondecode(data.http.debug_protection_cname[domain].response_body).data.getPublicCNAME
  }
}

# {"operationName":"PublicCNAME","variables":{"region":"eu-west-1","domains":["${local.webapp_names[0]}"],"profileId":"${local.profile_id}"},"query":"query PublicCNAME($region: String, $domains: [String], $profileId: String) {\n  getPublicCNAME(region: $region, domains: $domains, profileId: $profileId) {\n    domain\n    cname\n    __typename\n  }\n}\n"}

locals {
  protection_cnames = jsondecode(data.http.protection_cname.response_body).data.getPublicCNAME
}

output "protection_cnames" {
  value = local.protection_cnames
  
}

output "debug_protection_cnames" {
  value = data.http.protection_cname.response_body
  
}

output "debug_protection_cname_request" {
  value =  <<EOT
{"operationName":"PublicCNAME","variables":{"region":"eu-west-1","domains":${jsonencode(local.domain_names)},"profileId":"${var.profile_id}"},"query":"query PublicCNAME($region: String, $domains: [String], $profileId: String) {\n  getPublicCNAME(region: $region, domains: $domains, profileId: $profileId) {\n    domain\n    cname\n    __typename\n  }\n}\n"}
EOT
}

// <none>
# protection_cnames = [
#   {
#     "__typename" = "PublicCNAME"
#     "cname" = "one4xklaudonline.1d81c053-490f-460e-993d-284ec143aa42.eu-west-1.2f661b613795.i2.checkpoint.com"
#     "domain" = "one4x.klaud.online"

resource "cloudflare_record" "protection_cname" {

  for_each = { for cname in local.protection_cnames : 
    cname.domain => cname.cname
    if cname.cname != "<none>"
  }

  zone_id = var.CLOUDFLARE_DNS_ZONEID
  name    = each.key
  value   = each.value
  type    = "CNAME"
  ttl     = 3600
}

output "finished_domains" {
  value = [ for cname in cloudflare_record.protection_cname : cname.name ]
}