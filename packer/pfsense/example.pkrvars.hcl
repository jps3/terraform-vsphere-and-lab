# Change values and rename file to *.auto.pkrvars.hcl for
# automatic inclusion and use with `packer build .`

vcenter_datacenter  = "dc"
vcenter_cluster     = "cluster0"
vcenter_datastore   = "datastore1"
vcenter_host        = "esx1.local"
vcenter_folder      = "Templates"
insecure_connection = "true"
iso_datastore       = "datastore2"
iso_path            = "ISOs/pfSense-CE-2.5.2-RELEASE-amd64.iso"
iso_checksum        = "sha256:0266a16aa070cbea073fd4189a5a376d89c2d3e1dacc172c31f7e4e75b1db6bd"
vm_name             = "pfsense-2.5.2-amd64"
#output_directory    = "/some/path/to/different/export/folder/"
#num_cpu             = 1
#num_cores           = 1
#vm_ram              = 1024 # MiB
#root_disk_size      = 8192 # MiB