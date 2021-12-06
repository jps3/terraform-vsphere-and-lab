# Change values and rename file to *.auto.pkrvars.hcl for
# automatic inclusion and use with `packer build .`

vcenter_datacenter  = "dc"
vcenter_cluster     = "cluster0"
vcenter_datastore   = "datastore1"
vcenter_host        = "esx1.local"
vcenter_folder      = "Templates"
insecure_connection = "true"
iso_datastore       = "datastore2"
iso_path            = "ISOs/OPNsense-21.7.1-OpenSSL-dvd-amd64.iso"
iso_checksum        = "sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
vm_name             = "opnsense-21.7.1-amd64"
#output_directory    = "/some/path/to/different/export/folder/"