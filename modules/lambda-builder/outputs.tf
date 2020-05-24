output "build_ref" {
  value = local.trigger
  description = "id of build, used to determine if a rebuild should happen"
}

output "remote_key" {
  value = local.remote_key
  description = "remote key for file uploaded to s3"
}