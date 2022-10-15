# Single Page Application Example

This example deploys a Single Page Application, using the Authorization Code flow with PKCE S256 required token endpoint authentication.  The example also maps common oidc scopes, required/optional attributes and a group for access control, to the application.

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

Then execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Run `terraform destroy` when you don't need these resources.
