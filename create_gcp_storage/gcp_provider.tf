# gcp_provider.tf
// Configure the Google Cloud provider

variable "project" {}
variable "region" {}
variable "zone" {}

provider "google" {
  credentials = "${file("drone-sa.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}
