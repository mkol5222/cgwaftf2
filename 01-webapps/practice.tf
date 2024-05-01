# OUT: local.practice_id - id of WEB APPLICATION BEST PRACTICE

data "http" "practice" {
  url        = "https://cloudinfra-gw.portal.checkpoint.com/app/i2/graphql/V1"
  method     = "POST"
  request_headers = {
    "authorization" = "Bearer ${local.policy_token}"
    "content-type"  = "application/json"
  }
  request_body = <<EOT
{ "query": "query { getPractices(matchSearch: \"WEB APPLICATION BEST PRACTICE\", practiceType:\"WebApplication\") { id name practiceType } }" }
EOT
}

locals {
  practice_id = jsondecode(data.http.practice.body).data.getPractices[0].id
}

output "practice_id" {
  value = local.practice_id
}
