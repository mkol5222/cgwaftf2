# IN: var.enforce: true/false
# IN: local.policy_token
# DEPENDS ON: data.http.publishChanges

data "http" "enforcePolicy" {
  count      = var.publish && var.enforce ? 1 : 0
  depends_on = [data.http.publishChanges]

  url    = "https://cloudinfra-gw.portal.checkpoint.com/app/i2/graphql/V1"
  method = "POST"
  request_headers = {
    "authorization" = "Bearer ${local.policy_token}"
    "content-type"  = "application/json"
  }
  request_body = <<EOT
{ "query": "mutation { enforcePolicy { id } }" }
EOT
}

output "enforce_response" {
  value = var.enforce ? jsondecode(data.http.enforcePolicy[0].body) : {}
}

variable "enforce" {
  description = "Enforce policy?"
  type        = bool
  default     = false
}
