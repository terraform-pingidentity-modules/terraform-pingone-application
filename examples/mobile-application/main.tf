provider "pingone" {
  client_id      = var.p1_admin_client_id
  client_secret  = var.p1_admin_client_secret
  environment_id = var.p1_admin_environment_id
  region         = var.p1_region

  force_delete_production_type = false
}


#########################################################################
# Mobile Application
#########################################################################

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


#########################################################################
# Supporting Environment
#########################################################################

resource "pingone_environment" "my_environment" {
  name        = "Example Module - mobile-application"
  description = "My new environment to test the mobile-application module example"
  type        = "SANDBOX"
  license_id  = var.p1_license_id

  default_population {}

  service {
    type = "SSO"
  }

  service {
    type = "MFA"
  }
}

#########################################################################
# Supporting Group
#########################################################################

resource "pingone_group" "my_group" {
  environment_id = pingone_environment.my_environment.id

  name = "My Mobile App Group"
}

#########################################################################
# Supporting Sign on Policy 1
#########################################################################

resource "pingone_sign_on_policy" "my_policy_1" {
  environment_id = pingone_environment.my_environment.id

  name        = "Sign_On_1"
}

resource "pingone_sign_on_policy_action" "my_policy_1_first_factor" {
  environment_id    = pingone_environment.my_environment.id
  sign_on_policy_id = pingone_sign_on_policy.my_policy_1.id

  priority = 1

  conditions {
    last_sign_on_older_than_seconds = 86400 // 24 hours
  }

  login {
    recovery_enabled = true
  }

}

#########################################################################
# Supporting Sign on Policy 2
#########################################################################

resource "pingone_sign_on_policy" "my_policy_2" {
  environment_id = pingone_environment.my_environment.id

  name        = "Sign_On_2"
}

resource "pingone_sign_on_policy_action" "my_policy_2_identifier_first" {
  environment_id    = pingone_environment.my_environment.id
  sign_on_policy_id = pingone_sign_on_policy.my_policy_2.id

  priority = 1

  conditions {
    last_sign_on_older_than_seconds = 604800 // 7 days
  }

  identifier_first {
    recovery_enabled = true
  }
}

resource "pingone_sign_on_policy_action" "my_policy_2_first_factor" {
  environment_id    = pingone_environment.my_environment.id
  sign_on_policy_id = pingone_sign_on_policy.my_policy_2.id

  priority = 2

  conditions {
    last_sign_on_older_than_seconds = 86400 // 24 hours
  }

  login {
    recovery_enabled = true
  }
}


