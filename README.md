# Ping Identity PingOne Application Module

This module provides a set of reusable submodules with which to create PingOne Applications with associated assignments, including group assignment, sign-on policy assignment and straightforward attribute mapping.  Supports the easy creation of iOS and Android enabled native applications with push credentials.

## Usage

`mobile-application`:

```hcl
module "mobile_native_application" {
  source = "terraform-pingidentity-modules/application/pingone//modules/native-application"
  
  environment_id = pingone_environment.my_environment.id

  name           = "Example Mobile Application"
  description    = "Example Mobile Application that uses the Native type of application"
  enabled        = true
  
  # Apple
  mobile_app_bundle_id                        = var.mobile_app_bundle_id
  mobile_app_apns_key                         = var.mobile_app_apns_key
  mobile_app_apns_team_id                     = var.mobile_app_apns_team_id
  mobile_app_apns_token_signing_key           = var.mobile_app_apns_token_signing_key
  mobile_app_integrity_detection_ios_enabled  = true
  
  # Android
  mobile_app_package_name                        = var.mobile_app_package_name
  mobile_app_fcm_key                             = var.mobile_app_fcm_key
  mobile_app_integrity_detection_android_enabled = true

  mobile_app_integrity_detection_cache_duration_minutes = 1440 // 24 hours
  mobile_app_universal_app_link                         = var.mobile_app_universal_app_link

  sign_on_policy_assignment_id_list = [
    pingone_sign_on_policy.my_policy_mfa.id
  ]
}
```

`native-application`:

```hcl
module "native_application" {
  source = "terraform-pingidentity-modules/application/pingone//modules/native-application"
  
  environment_id = pingone_environment.my_environment.id

  name           = "Example Native Application"
  description    = "Example Native Application"
  enabled        = true

  grant_types     = ["AUTHORIZATION_CODE"]
  response_types  = ["CODE"]
  
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

- [mobile-application](https://github.com/terraform-pingidentity-modules/terraform-pingone-application/tree/main/examples/mobile-application) - Create a new Mobile Application enabled for iOS and Android mobile devices, with integrity detection and push notification credentials
- [native-application](https://github.com/terraform-pingidentity-modules/terraform-pingone-application/tree/main/examples/native-application) - Create a new Native Application
- [single-page-application](https://github.com/terraform-pingidentity-modules/terraform-pingone-application/tree/main/examples/single-page-application) - Create a new Single Page Application application with the default settings of Authorization Code grant type with PKCE S256 required token authentication
