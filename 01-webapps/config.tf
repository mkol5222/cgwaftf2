# IN:   spec/config.yaml: profile_name, mode (Learn/Prevent)
# OUT:  local.profile_id, local.mode

locals {
  config       = yamldecode(file("${path.module}/spec/config.yaml"))
  profile_name = local.config.profile_name
  mode         = local.config.mode
}