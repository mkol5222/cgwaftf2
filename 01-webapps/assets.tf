locals {
  assets = yamldecode(file("${path.module}/spec/assets.yaml"))
}

output "assets" {
  value = local.assets
}

resource "inext_trusted_sources" "my-trusted-source-behavior" {
  name                = "my sources"
  min_num_of_sources  = 1
  sources_identifiers = []
}

resource "inext_web_app_asset" "webapp-asset" {
  for_each = { for webapp in local.assets : webapp.name => {
    name          = webapp.name
    frontend_urls = ["https://${webapp.name}", "http://${webapp.name}"]
    backend_url   = webapp.backend
    profile_id    = local.profile_id
    host          = split("/", webapp.backend)[2]
    }
  }

  name     = each.value.name
  profiles = [each.value.profile_id]

  urls         = each.value.frontend_urls
  upstream_url = each.value.backend_url

  proxy_setting {
    key   = "isSetHeader"
    value = "true"
  }
  proxy_setting {
    key   = "setHeader"
    value = "Host:${each.value.host}"
  }

  practice {
    main_mode = local.mode
    id        = local.practice_id
  }
trusted_sources = [inext_trusted_sources.my-trusted-source-behavior.id]
source_identifier {
    identifier = "XForwardedFor" # enum of ["SourceIP", "XForwardedFor", "HeaderKey", "Cookie"]
    values     = []
  }
}
