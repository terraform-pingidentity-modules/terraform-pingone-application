variable "p1_admin_client_id" {
  
}

variable "p1_admin_client_secret" {
  
}

variable "p1_admin_environment_id" {
  
}

variable "p1_region" {
  
}

variable "p1_license_id" {
  
}

### Apple

variable "mobile_app_bundle_id" {
    type = string
    default = "org.bxretail.mobileapp.ios"
}

variable "mobile_app_apns_key" {
    type = string
    default = "dummyapnskey"
}

variable "mobile_app_apns_team_id" {
    type = string
    default = "team.id.dummyvalue"
}

variable "mobile_app_apns_token_signing_key" {
    type = string
    default = "-----BEGIN PRIVATE KEY-----dummyapnssigningkey-----END PRIVATE KEY-----"
}
  
### Android
variable "mobile_app_package_name" {
    type = string
    default = "org.bxretail.mobileapp.android"
}

variable "mobile_app_fcm_key" {
    type = string
    default = "dummyfcmkey"
}

variable "mobile_app_universal_app_link" {
    type = string
    default = "https://bxretail.org"
}