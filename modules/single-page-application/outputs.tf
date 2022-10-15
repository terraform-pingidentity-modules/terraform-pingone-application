output "id" {
  description = "The ID of the application."
  value       = try(pingone_application.this.id, "")
}

output "client_id" {
  description = "A string that specifies the application ID used to authenticate to the authorization server."
  value       = try(pingone_application.this.oidc_options[0].client_id, "")
}

output "client_secret" {
  description = "A string that specifies the application secret ID used to authenticate to the authorization server."
  sensitive   = true
  value       = try(pingone_application.this.oidc_options[0].client_secret, "")
}
