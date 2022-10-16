# iOS / Android Mobile Application Example

This example deploys a Mobile Application enabled for iOS and Android mobile devices, with integrity detection and push notification credentials.  The example also maps common oidc scopes, required/optional attributes and a group for access control, to the application.

# Usage

To run this example you need to:

Set the following variables:
```bash
export TF_VAR_p1_admin_environment_id=$P1_ADMIN_ENV_ID
export TF_VAR_p1_admin_client_id=$P1_ADMIN_CLIENT_ID
export TF_VAR_p1_admin_client_secret=$P1_ADMIN_CLIENT_SECRET
export TF_VAR_p1_region=$P1_REGION
export TF_VAR_p1_license_id=$P1_LICENSE_ID
```

Optionally set the following variables to align with your mobile app.  If the following variables are not set, default dummy values will be used to for demonstration purposes:
```bash
export TF_VAR_mobile_app_universal_app_link=$MOBILE_APP_UNIVERSAL_APP_LINK

echo "IOS.."
export TF_VAR_mobile_app_bundle_id=$MOBILE_APP_IOS_BUNDLE_ID
export TF_VAR_mobile_app_apns_key=$MOBILE_APP_IOS_APNS_KEY
export TF_VAR_mobile_app_apns_team_id=$MOBILE_APP_IOS_APNS_TEAM_ID
export TF_VAR_mobile_app_apns_token_signing_key=$MOBILE_APP_IOS_APNS_TOKEN_SIGNING_KEY

echo "Android.."
export TF_VAR_mobile_app_package_name=$MOBILE_APP_ANDROID_PACKAGE_NAME
export TF_VAR_mobile_app_fcm_key=$MOBILE_APP_ANDROID_FCM_KEY
```

Then execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Run `terraform destroy` when you don't need these resources.
