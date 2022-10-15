provider "pingone" {
  client_id      = var.p1_admin_client_id
  client_secret  = var.p1_admin_client_secret
  environment_id = var.p1_admin_environment_id
  region         = var.p1_region

  force_delete_production_type = false
}


#########################################################################
# Single Page Application
#########################################################################

module "spa_application" {
  source = "../../modules/single-page-application"

  environment_id = pingone_environment.my_environment.id

  name           = "Example SPA"
  description    = "Example Single Page Application"
  enabled        = true
  
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
  name        = "Example Module - single-page-application"
  description = "My new environment to test the single-page-application module example"
  type        = "SANDBOX"
  license_id  = var.p1_license_id

  default_population {}

  service {
    type = "SSO"
  }
}

#########################################################################
# Supporting Group
#########################################################################

resource "pingone_group" "my_group" {
  environment_id = pingone_environment.my_environment.id

  name = "My SPA Group"
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


