output "gitea_url" {
  description = "Access your Gitea instance at this URL"
  value       = "ACCESS YOUR GITEA INSTANCE HERE --> http://${aws_eip.gitea_eip.public_ip}:3000/"
}


# output "private_key_pem" {
#   description = "Private key data in PEM (RFC 1421) format"
#   value       = module.key_pair.private_key_pem
#   sensitive   = true
# }

# output "public_key_fingerprint_md5" {
#   description = "The fingerprint of the public key data in OpenSSH MD5 hash format, e.g. `aa:bb:cc:....` Only available if the selected private key format is compatible, similarly to `public_key_openssh` and the ECDSA P224 limitations"
#   value       = module.key_pair.public_key_fingerprint_md5
# }

# output "public_key_fingerprint_sha256" {
#   description = "The fingerprint of the public key data in OpenSSH SHA256 hash format, e.g. `SHA256:....` Only available if the selected private key format is compatible, similarly to `public_key_openssh` and the ECDSA P224 limitations"
#   value       = module.key_pair.public_key_fingerprint_sha256
# }

# output "public_key_openssh" {
#   description = "The public key data in \"Authorized Keys\" format. This is populated only if the configured private key is supported: this includes all `RSA` and `ED25519` keys"
#   value       = module.key_pair.public_key_openssh
# }

# output "public_key_pem" {
#   description = "Public key data in PEM (RFC 1421) format"
#   value       = module.key_pair.public_key_pem
# }