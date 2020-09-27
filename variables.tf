variable "region" {
  description = "Region of GCE resources"
  default     = ""
}
variable "zone" {
  description = "Region of GCE resources"
  default     = ""
}

variable "project" {
	 description = "Name of GCE project"
   default=""
}

variable "credentials" {
  description = "Path to the JSON file used to describe your account credentials"
  default = ""
}
