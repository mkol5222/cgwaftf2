# IN:   local.profile_name: waf profile name
# OUT:  local.profile_id: waf profile id

data "http" "profiles" {

  url    = "https://cloudinfra-gw.portal.checkpoint.com/app/i2/graphql/V1"
  method = "POST"
  request_headers = {
    "authorization" = "Bearer ${local.policy_token}"
    "content-type"  = "application/json"
  }
  request_body = <<EOT
    { 
        "query": "query getProfiles($matchSearch: String) { getProfiles(matchSearch: $matchSearch) { id name profileType }}",
        "variables": { "matchSearch": "${local.profile_name}" } 
    }
EOT
}

locals {
  profile_id = jsondecode(data.http.profiles.body).data.getProfiles[0].id
}

output "profile_id" {
  value = local.profile_id
}
