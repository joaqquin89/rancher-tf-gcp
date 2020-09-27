provider "google" {
  credentials = "${file(var.credentials)}"
  project     = "${var.project}"
  region      = "${var.region}"
  zone        = "${var.zone}"
}

module "rancher-server"{
  source = "./modules/rancher-server"
  public_key_path = "/Users/joaquinjachurachavez/.ssh/id_rsa.pub"
  private_key_path = "/Users/joaquinjachurachavez/.ssh/id_rsa"
  image="ubuntu-os-cloud/ubuntu-minimal-1604-xenial-v20200702"
  rs_proj_name = "${var.project}"
  dns-name = "www.e-ferreterias.com"
}