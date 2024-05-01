# IN: var.APPSEC_CLIENT_ID, var.APPSEC_SECRET_KEY
# OUT: locals.token_appsec

data "http" "login_appsec" {
  url    = "https://cloudinfra-gw.portal.checkpoint.com/auth/external"
  method = "POST"
  request_body = jsonencode({
    clientId  = var.APPSEC_CLIENT_ID
    accessKey = var.APPSEC_SECRET_KEY
  })
  request_headers = {
    "content-type" = "application/json"
  }
}

locals {
  token_appsec = jsondecode(data.http.login_appsec.response_body)["data"]["token"]
}