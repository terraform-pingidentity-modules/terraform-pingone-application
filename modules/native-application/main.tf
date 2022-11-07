locals {


}

####### PINGONE

#########################################################################
# Application Icon
#########################################################################

resource "pingone_image" "this" {

  count = var.image_file_location != null ? 1 : 0

  environment_id = var.environment_id

  image_file_base64 = filebase64(var.image_file_location)
}

#########################################################################
# Application
#########################################################################

resource "pingone_application" "this" {
  environment_id = var.environment_id
  name           = var.name
  enabled        = var.enabled
  description    = var.description

  access_control_role_type = var.admin_role_required ? "ADMIN_USERS_ONLY" : null

  login_page_url = var.login_page_url != null && var.login_page_url != "" ? var.login_page_url : null

  dynamic "icon" {
    for_each = pingone_image.this

    content {
      id   = pingone_image.this[0].id
      href = pingone_image.this[0].uploaded_image[0].href
    }
  }

  dynamic "access_control_group_options" {
    for_each = var.group_access_control_id_list != null && length(var.group_access_control_id_list) > 0 ? [true] : []

    content {
      type   = var.group_access_control_type
      groups = var.group_access_control_id_list
    }
  }

  oidc_options {

    home_page_url = var.home_page_url != null && var.home_page_url != "" ? var.home_page_url : null

    type                            = "NATIVE_APP"
    grant_types                     = var.grant_types
    response_types                  = var.response_types
    pkce_enforcement                = var.pkce_enforcement
    token_endpoint_authn_method     = var.token_endpoint_authn_method
    redirect_uris                   = try(var.redirect_uris, [])
    post_logout_redirect_uris       = try(var.post_logout_redirect_uris, [])
    support_unsigned_request_object = try(var.support_unsigned_request_object, null)
  
    ## Mobile App
    bundle_id = try(var.mobile_app_bundle_id, null)
    package_name = try(var.mobile_app_package_name, null)

    dynamic "mobile_app" {

      for_each = (var.mobile_app_bundle_id != null && var.mobile_app_bundle_id != "") || (var.mobile_app_package_name != null && var.mobile_app_package_name != "") ? [true] : []

      content {
        bundle_id = var.mobile_app_bundle_id
        package_name = var.mobile_app_package_name

        dynamic "integrity_detection" {

          for_each = var.mobile_app_integrity_detection_ios_enabled || var.mobile_app_integrity_detection_android_enabled ? [true] : []
          
          content {
            enabled = true
            
            cache_duration {
              amount = var.mobile_app_integrity_detection_cache_duration_minutes
              units = "MINUTES"
            }

            excluded_platforms = concat(
              var.mobile_app_integrity_detection_ios_enabled ? [] : ["IOS"],
              var.mobile_app_integrity_detection_android_enabled ? [] : ["GOOGLE"]
            )
          }
        }

        passcode_refresh_seconds = try(var.mobile_app_passcode_refresh_duration_seconds, null)
        universal_app_link = try(var.mobile_app_universal_app_link, null)
      }

    }
  }

}

#########################################################################
# APNS Push Notification Credential
#########################################################################

resource "pingone_mfa_application_push_credential" "apns" {
  
  count = (var.mobile_app_apns_key != null && var.mobile_app_apns_key != "") && (var.mobile_app_apns_team_id != null && var.mobile_app_apns_team_id != "") && (var.mobile_app_apns_token_signing_key != null && var.mobile_app_apns_token_signing_key != "") ? 1 : 0

  environment_id = var.environment_id
  application_id = pingone_application.this.id

  apns {
    key               = var.mobile_app_apns_key
    team_id           = var.mobile_app_apns_team_id
    token_signing_key = var.mobile_app_apns_token_signing_key
  }
}

#########################################################################
# FCM Push Notification Credential
#########################################################################

resource "pingone_mfa_application_push_credential" "fcm" {
  
  count = var.mobile_app_fcm_key != null && var.mobile_app_fcm_key != "" ? 1 : 0

  environment_id = var.environment_id
  application_id = pingone_application.this.id

  fcm {
    key = var.mobile_app_fcm_key
  }
}

#########################################################################
# Application Attribute Mapping
#########################################################################

resource "pingone_application_attribute_mapping" "this" {

  count = var.attribute_mapping != null && length(var.attribute_mapping) > 0 ? length(var.attribute_mapping) : 0

  environment_id = var.environment_id
  application_id = pingone_application.this.id

  name  = var.attribute_mapping[count.index].name
  value = var.attribute_mapping[count.index].value

  required = var.attribute_mapping[count.index].required
}


#########################################################################
# Application Sign on Policy Assignment
#########################################################################

resource "pingone_application_sign_on_policy_assignment" "this" {

  count = var.sign_on_policy_assignment_id_list != null && length(var.sign_on_policy_assignment_id_list) > 0 ? length(var.sign_on_policy_assignment_id_list) : 0

  environment_id = var.environment_id
  application_id = pingone_application.this.id

  sign_on_policy_id = var.sign_on_policy_assignment_id_list[count.index]

  priority = count.index + 1
}

#########################################################################
# OpenID Scopes
#########################################################################

data "pingone_resource" "openid_resource" {

  count = var.openid_scopes != null && length(var.openid_scopes) > 0 ? 1 : 0

  environment_id = var.environment_id

  name = "openid"
}

data "pingone_resource_scope" "openid_scope" {

  count = var.openid_scopes != null && length(var.openid_scopes) > 0 ? length(var.openid_scopes) : 0

  environment_id = var.environment_id
  resource_id    = data.pingone_resource.openid_resource[0].id

  name = var.openid_scopes[count.index]
}

resource "pingone_application_resource_grant" "openid_scope_assignment" {

  count = var.openid_scopes != null && length(var.openid_scopes) > 0 ? 1 : 0

  environment_id = var.environment_id
  application_id = pingone_application.this.id

  resource_id = data.pingone_resource.openid_resource[0].id

  scopes = flatten([data.pingone_resource_scope.openid_scope[*].id])
}
