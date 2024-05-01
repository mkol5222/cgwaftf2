# IN:   var.POLICY_CLIENT_ID, var.POLICY_SECRET_KEY
# OUT:  local.policy_token: auth token for CloudGuard WAF (Infinity Portal app Policy)

data "http" "policy_token" {
  url    = "https://cloudinfra-gw.portal.checkpoint.com/auth/external"
  method = "POST"
  request_body = jsonencode({
    clientId  = var.POLICY_CLIENT_ID
    accessKey = var.POLICY_SECRET_KEY
  })
  request_headers = {
    "content-type" = "application/json"
  }
}

locals {
  policy_token = jsondecode(data.http.policy_token.response_body)["data"]["token"]
}