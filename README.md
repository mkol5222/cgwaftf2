
# 01. Manage web app assets in CloudGuard WAF declarative

```shell
# manage based on YAML spec
# ./01-webapps/spec/assets.yaml
- name: one4x.klaud.online
  backend: https://one.one.one.one
- name: dev2.klaud.online
  backend: https://dev.to

# with defaults:
# ./01-webapps/spec/config.yaml
profile: saas-feb15
mode: Prevent
```

Inputs:
- POLICY_CLIENT_ID - Infinity Portral API key, application "Policy"
- POLICY_SECRET_KEY