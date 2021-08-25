packer {
  required_plugins {
    googlecompute = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

variable "crc_version" {
  type    = string
  default = "1.31.2"
}
variable "project_id" {
  type    = string
  default = "instruqt-322418"
}
variable "machine_type" {
  type    = string
  default = "e2-standard-8"
  #default = "n1-standard-2"
  #default = "n1-standard-4"
}

source "googlecompute" "crc" {
  project_id = var.project_id

  region = "us-west1"
  zone   = "us-west1-a"
  #region     = "northamerica-northeast2"
  #zone       = "northamerica-northeast2-a"
  machine_type = var.machine_type
  disk_size    = 40

  ssh_username = "core"
  #ssh_private_key_file = "id_ecdsa_crc"

  source_image_family = "crc"
  source_image        = "https://storage.googleapis.com/crc-vm/crc-1.31.2/crc-1.31.2.vmdk"
  image_family        = regex_replace("crc-${regex_replace(var.crc_version, "\\+.*$", "")}", "[^a-zA-Z0-9_-]", "-")
  image_name          = regex_replace("crc-${var.crc_version}-${uuidv4()}", "[^a-zA-Z0-9_-]", "-")
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
  #    source      = ""
  #    destination = "/opt/kube-dashboard/dashboard-sa.yml"
  #}
}
