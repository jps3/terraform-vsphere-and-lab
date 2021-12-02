# Change values and rename file to *.auto.pkrvars.hcl for
# automatic inclusion and use with `packer build .`

vcenter_datacenter  = "dc"
vcenter_cluster     = "cluster0"
vcenter_datastore   = "datastore1"
vcenter_host        = "esx1.local"
vcenter_folder      = "Templates"
insecure_connection = "true"
iso_datastore       = "datastore2"
iso_path            = "ISOs/install70.iso"
iso_checksum        = "sha256:1882f9a23c9800e5dba3dbd2cf0126f552605c915433ef4c5bb672610a4ca3a4"
vm_name             = "openbsd-7.0-amd64"
#output_directory    = "/some/path/to/different/export/folder/"
#first_user_username = "someuser"
#first_user_pubkey   = "ssh-rsa ..."
#tz                  = "US/Eastern"