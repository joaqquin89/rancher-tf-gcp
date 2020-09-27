

variable "region_zone" {
  description = "Region and Zone of GCE resources"
  default     = "us-east1-c"
}

variable "machine_type" {
	description = "Type of VM to be created"
	default 		= "n1-standard-1"
}
variable "image" {
	description = "Name of the OS image for compute instances"
	default		  = "ubuntu-os-cloud/ubuntu-1404-trusty-v20161020"
}

variable "public_key_path" {
  description = "Path to file containing public key"
}

variable "private_key_path" {
  description = "Path to file containing private key"
}

variable "install_script_src_path" {
  description = "Path to install script within this repository"
  default     = "install.sh"
}

variable "install_script_dest_path" {
  description = "Path to put the install script on each destination resource"
  default     = "/tmp/install.sh"
}

variable "rs_proj_name" {
  description = "Name of the rancher project"
}

variable "dns-name" {
  description = "Name of the dns service"
}