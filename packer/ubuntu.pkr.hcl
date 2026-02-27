packer {
  required_version = ">= 1.9.0"

  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.1.0"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.1.0"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = ">= 1.0.0"
    }
  }
}

variable "box_name"             { type = string }
variable "cloud_image_url"      { type = string }
variable "cloud_image_checksum" { type = string }
variable "cpus"                 { type = number }
variable "memory"               { type = number }
variable "disk_size"            { type = string }
variable "ssh_username"         { type = string }
variable "ssh_password"         { type = string }

source "qemu" "ubuntu" {
  iso_url      = var.cloud_image_url
  iso_checksum = var.cloud_image_checksum
  disk_image   = true

  output_directory = "output-${var.box_name}"
  vm_name          = "${var.box_name}.qcow2"
  format           = "qcow2"

  cpus      = var.cpus
  memory    = var.memory
  disk_size = var.disk_size

  cd_files = [
    "${path.root}/cloud-init/meta-data",
    "${path.root}/cloud-init/user-data",
  ]
  cd_label = "cidata"

  headless       = true
  accelerator    = "kvm"
  net_device     = "virtio-net"
  disk_interface = "virtio"

  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = "20m"

  shutdown_command = "sudo systemctl poweroff"
}

build {
  name    = var.box_name
  sources = ["source.qemu.ubuntu"]

  provisioner "shell" {
    inline = ["cloud-init status --wait || true"]
  }

  provisioner "ansible" {
    playbook_file    = "${path.root}/../ansible/site.yml"
    ansible_env_vars = ["ANSIBLE_ROLES_PATH=${path.root}/../ansible/roles"]
    extra_arguments  = ["-v"]
    user             = var.ssh_username
  }

  post-processor "vagrant" {
    output            = "${var.box_name}.box"
    provider_override = "libvirt"
  }
}
