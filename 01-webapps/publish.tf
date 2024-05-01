# IN: var.publish: true/false
# IN: local.policy_token

data "http" "publishChanges" {
  count = var.publish ? 1 : 0

  depends_on = [inext_web_app_asset.webapp-asset]
  url        = "https://cloudinfra-gw.portal.checkpoint.com/app/i2/graphql/V1"
  method     = "POST"
  request_headers = {
    "authorization" = "Bearer ${local.policy_token}"
    "content-type"  = "application/json"
  }
  request_body = <<EOT
{ "query": "mutation {\n publishChanges {\n isValid\n errors {\n id type subType name message \n }\n warnings {\n id type subType name message\n }\n }\n }" }
EOT
}

output "publish_response" {
  value = var.publish ? jsondecode(data.http.publishChanges[0].body) : {}
}

variable "publish" {
  description = "Publish policy?"
  type        = bool
  default     = false
}