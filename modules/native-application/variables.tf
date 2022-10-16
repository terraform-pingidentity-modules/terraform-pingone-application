variable "environment_id" {
  description = "The ID of the environment to create the application in."
  type        = string
}

variable "name" {
  description = "A string that specifies the name of the application."
  type        = string
}

variable "description" {
  description = "A string that specifies the description of the application."
  type        = string
  default     = ""
}

variable "enabled" {
  description = "A boolean that specifies whether the application is enabled in the environment. Defaults to `false`."
  type        = bool
  default     = false
}

variable "login_page_url" {
  description = "A string that specifies the custom login page URL for the application. If you set the login_page_url property for applications in an environment that sets a custom domain, the URL should include the top-level domain and at least one additional domain level. Warning To avoid issues with third-party cookies in some browsers, a custom domain must be used, giving your PingOne environment the same parent domain as your authentication application. For more information about custom domains, see Custom domains."
  type        = string
  default     = ""
}

variable "home_page_url" {
  description = "A string that specifies the custom home page URL for the application."
  type        = string
  default     = ""
}

variable "admin_role_required" {
  description = "A boolean that specifies whether users require an admin role to be able to access the application.  Defaults to `false`."
  type        = bool
  default     = false
}

variable "group_access_control_type" {
  description = "A string that specifies the group type required to access the application. Options are `ANY_GROUP` (default; the actor must belong to at least one group listed in the groups property) and `ALL_GROUPS` (the actor must belong to all groups listed in the groups property)."
  type        = string
  default     = "ANY_GROUP"
}

variable "group_access_control_id_list" {
  description = "A set that specifies the group IDs for the groups the actor must belong to for access to be granted to the application."
  type        = list(string)
  default     = []
}

variable "grant_types" {
  description = "A list that specifies the grant type for the authorization request. Options are `AUTHORIZATION_CODE`, `IMPLICIT`, `REFRESH_TOKEN` and `CLIENT_CREDENTIALS`.  Defaults to `CLIENT_CREDENTIALS`."
  type        = list(string)
  default     = ["CLIENT_CREDENTIALS"]
}

variable "response_types" {
  description = "A list that specifies the code or token type returned by an authorization request. Note that `CODE` cannot be used in an authorization request with `TOKEN` or `ID_TOKEN` because PingOne does not currently support OIDC hybrid flows."
  type        = list(string)
  default     = []
}

variable "pkce_enforcement" {
  description = "A string that specifies how PKCE request parameters are handled on the authorize request. Options are `OPTIONAL`, `REQUIRED` and `S256_REQUIRED`. Defaults to `OPTIONAL`."
  type        = string
  default     = "OPTIONAL"
}

variable "token_endpoint_authn_method" {
  description = "A string that specifies the client authentication methods supported by the token endpoint. Options are `NONE`, `CLIENT_SECRET_BASIC` and `CLIENT_SECRET_POST`.  Defaults to `CLIENT_SECRET_BASIC`."
  type        = string
  default     = "CLIENT_SECRET_BASIC"
}

variable "redirect_uris" {
  description = "A set of strings that specifies the callback URI for the authentication response."
  type        = list(string)
  default     = null
}

variable "post_logout_redirect_uris" {
  description = "A set of strings that specifies the URLs that the browser can be redirected to after logout."
  type        = list(string)
  default     = []
}

variable "support_unsigned_request_object" {
  description = "A boolean that specifies whether the request query parameter JWT is allowed to be unsigned. If `false`, an unsigned request object is not allowed. Defaults to `false`."
  type        = bool
  default     = false
}

variable "attribute_mapping" {
  description = "A map of attribute mappings to configure on the application."
  type = list(object({
    name     = string
    value    = string
    required = optional(bool, false)
  }))
  default = []
}

variable "sign_on_policy_assignment_id_list" {
  description = "An ordered list of sign-on policy IDs that should be assigned to the application.  If left blank, the environment's default policy will be applied."
  type        = list(string)
  default     = []
}

variable "openid_scopes" {
  description = "A list of openid scopes that should be assigned to the application."
  type        = list(string)
  default     = []
}

## Mobile App specific

variable "mobile_app_bundle_id" {
  description = "A string that specifies the bundle associated with the application, for push notifications in native apps. The value of the `mobile_app_bundle_id` property is unique per environment, and once defined, is immutable; any change will force recreation of the application resource."
  type = string
  default = null
}

variable "mobile_app_package_name" {
  description = "A string that specifies the package name associated with the application, for push notifications in native apps. The value of the `mobile_app_package_name` property is unique per environment, and once defined, is immutable."
  type = string
  default = null
}

variable "mobile_app_apns_key" {
  description = "A string that Apple uses as an identifier to identify an authentication key."
  type = string
  sensitive = true
  default = null
}

variable "mobile_app_apns_team_id" {
  description = "A string that Apple uses as an identifier to identify teams."
  type = string
  default = null
}

variable "mobile_app_apns_token_signing_key" {
  description = "A string that Apple uses as the authentication token signing key to securely connect to APNS. This is the contents of a p8 file with a private key format."
  type = string
  sensitive = true
  default = null
}

variable "mobile_app_fcm_key" {
  description = "A string that represents the server key of the Firebase cloud messaging service."
  type = string
  sensitive = true
  default = null
}

variable "mobile_app_passcode_refresh_duration_seconds" {
  description = "The amount of time (in seconds) a passcode should be displayed before being replaced with a new passcode - must be between 30 and 60.  Defaults to 30"
  type = number
  default = 30
}

variable "mobile_app_universal_app_link" {
  description = "A string that specifies a URI prefix that enables direct triggering of the mobile application when scanning a QR code. The URI prefix can be set to a universal link with a valid value (which can be a URL address that starts with `HTTP://` or `HTTPS://`, such as `https://www.bxretail.org`), or an app schema, which is just a string and requires no special validation."
  type = string
  default = null
}

variable "mobile_app_integrity_detection_ios_enabled" {
  description = "A boolean that specifies whether device integrity detection takes place on iOS mobile devices. Defaults to `false`."
  type = bool
  default = false
}

variable "mobile_app_integrity_detection_android_enabled" {
  description = "A boolean that specifies whether device integrity detection takes place on Android mobile devices. Defaults to `false`."
  type = bool
  default = false
}

variable "mobile_app_integrity_detection_cache_duration_minutes" {
  description = "An integer that specifies the number of minutes that specify the duration between successful integrity detection calls. Defaults to 1440 minutes (24 hours)."
  type = number
  default = 1440
}
