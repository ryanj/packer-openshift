packer {
  required_plugins {
    googlecompute = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

variable "crc_version" {
  type = string
}
variable "project_id" {
  type    = string
  default = "instruqt"
}

source "googlecompute" "crc" {
  project_id          = var.project_id
  source_image_family = "rhel-8"
  ssh_username        = "rhel"
  region              = "europe-west1"
  zone                = "europe-west1-b"
  machine_type        = "n1-standard-2"
  #machine_type        = "n1-standard-4"
  disk_size    = 20
  image_family = regex_replace("crc-${regex_replace(var.crc_version, "\\+.*$", "")}", "[^a-zA-Z0-9_-]", "-")
  image_name   = regex_replace("crc-${var.crc_version}-${uuidv4()}", "[^a-zA-Z0-9_-]", "-")
}

build {
  sources = ["sources.googlecompute.crc"]

  provisioner "shell" {
    inline = [
      "sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm",
      "sudo dnf install -y jq",
    ]
  }
  # TODO: copy oc and podman-remote from bundle
  # TODO: include pull secret


  # Examples:
  #
  #provisioner "shell" {
  #    inline = ["mkdir -p /opt/kube-dashboard"]
  #}
  #provisioner "shell" {
  #    script = "files/crc-install.sh"
  #    environment_vars = [
  #        "CRC_VERSION=${ var.crc_version }"
  #    ]
  #}

  #provisioner "file" {
  #    source      = "files/dashboard-sa.yml"
  #    destination = "/opt/kube-dashboard/dashboard-sa.yml"
  #}
}
