packer {
  required_plugins {
    vsphere = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}

build {
  sources = ["source.vsphere-iso.openbsd"]
}
