resource "google_dns_managed_zone" "rancher-zone" {
  name        = "e-ferreterias"
  dns_name    = "e-ferreterias.com."
  description = "DNSracher zone"
  labels = {
    dns-zone = "rancher-server"
  }
}

resource "google_compute_instance" "rancher" {
  name = "rancher-work"
  machine_type = "${var.machine_type}"
  //zone         = "${var.region_zone}"
  tags         = ["rancher-server"]

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }


  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP - leaving this block empty will generate a new external IP and assign it to the machine
    }
  }

  metadata = {
    ssh-keys = "root:${file("${var.public_key_path}")}"
  }

 provisioner "file" {
    source      = "/Users/joaquinjachurachavez/Desktop/rancher-tf-gce/modules/rancher-server/install.sh"
    destination = "${var.install_script_dest_path}"

    connection {
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }
  }
    provisioner "remote-exec" {
        inline = [
          "chmod +x /tmp/install.sh",
          "/tmp/install.sh ${var.dns-name}"
        ]
    }
    connection {
      type        = "ssh"
      user        = "root"
      host        = "${google_compute_instance.rancher.network_interface.0.access_config.0.nat_ip}"
      private_key = "${file("${var.private_key_path}")}"
      agent       = false
    }

}

resource "google_dns_record_set" "frontend" {
  name = "www.${google_dns_managed_zone.rancher-zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.rancher-zone.name

  rrdatas = [google_compute_instance.rancher.network_interface[0].access_config[0].nat_ip]
}