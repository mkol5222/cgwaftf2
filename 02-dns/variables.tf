variable "APPSEC_CLIENT_ID" {
  description = "API KEY: The client ID of CloudGuard WAF = Infinity Portal app AppSec (new WAF API)"
  type        = string
}

variable "APPSEC_SECRET_KEY" {
  description = "API KEY: The secret key of CloudGuard WAF = Infinity Portal app AppSec (new WAF API)"
  type        = string
}

variable "CLOUDFLARE_DNS_API_TOKEN" {
  description = "API KEY: Cloudflare DNS API Token"
  type        = string
}

variable "CLOUDFLARE_DNS_ZONEID" {
  description = "Cloudflare DNS Zone ID"
  type        = string
}

variable "profile_id" {
  description = "SaaS profile ID from previouis step"
  type        = string
}