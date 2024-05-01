output "deployed_webapps" {
    value = [for webapp in inext_web_app_asset.webapp-asset : webapp.name]
}