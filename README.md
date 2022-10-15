# Ping Identity PingOne Application Module

This module provides a set of reusable submodules with which to create PingOne Applications with associated assignments, including group assignment, sign-on policy assignment and straightforward attribute mapping:

## Usage

`single-page-application`:

```hcl
module "spa_application" {
  source = "terraform-pingidentity-modules/application/pingone//modules/single-page-application"

  environment_id = pingone_environment.my_environment.id

  name           = "Example SPA"
  description    = "Example Single Page Application"
  enabled        = true

  grant_types    = ["AUTHORIZATION_CODE"]
  response_types = ["CODE"]

  pkce_enforcement            = "S256_REQUIRED"
  token_endpoint_authn_method = "NONE"
  
  group_access_control_id_list = [
    pingone_group.my_group.id
  ]
  
  redirect_uris = [
    "https://bxretail.org",
    "https://bxretail.org/signon",
    "https://www.bxretail.org",
    "https://www.bxretail.org/signon",
  ]
  
  post_logout_redirect_uris = [
    "https://bxretail.org/signoff",
    "https://www.bxretail.org/signoff"
  ]

  attribute_mapping = [
    {
      name     = "email"
      value    = "$${user.email}"
      required = true
    },
    {
      name  = "full_name"
      value = "$${user.name.given + ', ' + user.name.family}"
    },
    {
      name  = "first_name"
      value = "$${user.name.given}"
    },
    {
      name  = "last_name"
      value = "$${user.name.family}"
    },
  ]

  sign_on_policy_assignment_id_list = [
    pingone_sign_on_policy.my_policy_1.id,
    pingone_sign_on_policy.my_policy_2.id,
  ]

  openid_scopes = [
    "email",
    "profile",
    "address"
  ]

}
```

## Examples

- [single-page-application](https://github.com/terraform-pingidentity-modules/terraform-pingone-application/tree/main/examples/single-page-application) - Create a new Single Page Application application with the default settings of Authorization Code grant type with PKCE S256 required token authentication
