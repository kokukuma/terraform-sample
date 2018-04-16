# gcp_storage.tf
resource "google_storage_bucket" "terraform-store" {
  name     = "terraform-test-bucket"
  location = "ASIA"

  storage_class = "nearline"
}

resource "google_storage_bucket_acl" "remote-acl" {
  bucket         = "${google_storage_bucket.terraform-store.name}"
  predefined_acl = "private"
}
