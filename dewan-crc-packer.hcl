# the k3s stuff won't be needed later. these are kept now just so that the scripts don't fail
variable "k3s_version" {
  type    = string
  default = "v1-21-1"
}

source "googlecompute" "k3s" {
  project_id = "instruqt-dewan"
  region     = "northamerica-northeast2"
  zone       = "northamerica-northeast2-a"

  image_family = regex_replace("k3s-${regex_replace(var.k3s_version, "\\+.*$", "")}", "[^a-zA-Z0-9_-]", "-")
  image_name   = regex_replace("k3s-${var.k3s_version}-${uuidv4()}", "[^a-zA-Z0-9_-]", "-")

  source_image_family = "crc"
  machine_type        = "e2-standard-8"
  disk_size           = 40

  ssh_username = "rhel"
}

build {
  sources = ["source.googlecompute.k3s"]

  provisioner "shell" {
    script = "files/k3s-install.sh"
    environment_vars = [
      "K3S_VERSION=${var.k3s_version}"
    ]
  }

  provisioner "file" {
    sources = [
      "files/k3s.service",
      "files/kubectl-proxy.service",
      "files/kube-dashboard.service",
    ]
    destination = "/etc/systemd/system/"
  }

  provisioner "file" {
    source      = "files/k3s-start.sh"
    destination = "/usr/local/bin/k3s-start.sh"
  }

  provisioner "file" {
    source      = "files/start.sh"
    destination = "/usr/bin/start.sh"
  }

  provisioner "shell" {
    inline = ["mkdir -p /opt/kube-dashboard"]
  }

  provisioner "file" {
    source      = "files/dashboard.yml"
    destination = "/opt/kube-dashboard/dashboard.yml"
  }

  provisioner "file" {
    source      = "files/dashboard-sa.yml"
    destination = "/opt/kube-dashboard/dashboard-sa.yml"
  }
}
