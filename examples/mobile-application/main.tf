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

  sign_on_policy_assignment_id_list = [
    pingone_sign_on_policy.my_policy_mfa.id
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
# Supporting Sign on Policy
#########################################################################

resource "pingone_sign_on_policy" "my_policy_mfa" {
  environment_id = pingone_environment.my_environment.id

  name        = "Sign_On_Mobile_MFA"
}

resource "pingone_sign_on_policy_action" "my_policy_mfa" {
  environment_id    = pingone_environment.my_environment.id
  sign_on_policy_id = pingone_sign_on_policy.my_policy_mfa.id

  priority = 1

  conditions {
    last_sign_on_older_than_seconds = 86400 // 24 hours
  }

  mfa {
    device_sign_on_policy_id = pingone_mfa_policy.mfa_policy.id
  }

}


#########################################################################
# Supporting MFA Policy
#########################################################################

resource "pingone_mfa_policy" "mfa_policy" {
  environment_id = pingone_environment.my_environment.id
  name           = "Sample Mobile Authenticator Policy"

  sms {
    enabled = false
  }

  voice {
    enabled = false
  }

  email {
    enabled = false
  }

  mobile {
    enabled = true

    otp_failure_count = 5

    application {
      id = module.mobile_native_application.id

      push_enabled = true
      otp_enabled  = true

      device_authorization_enabled = true
      device_authorization_extra_verification = "restrictive"

      auto_enrollment_enabled = true

      integrity_detection = "permissive"
    }
  }

  totp {
    enabled = false
  }

  security_key {
    enabled = false
  }

  platform {
    enabled = false
  }

}