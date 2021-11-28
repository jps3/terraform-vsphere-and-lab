# ╭─────────────────────────────────╮
# │    ┏━┓┏━┓┏━┓╻ ╻╻╺┳┓┏━╸┏━┓┏━┓    │
# │    ┣━┛┣┳┛┃ ┃┃┏┛┃ ┃┃┣╸ ┣┳┛┗━┓    │
# │    ╹  ╹┗╸┗━┛┗┛ ╹╺┻┛┗━╸╹┗╸┗━┛    │
# ╰─────────────────────────────────╯

provider "vsphere" {
  allow_unverified_ssl = var.vs_insecure_connection
}


# ╭─────────────────────────────────╮
# │    ┏┳┓┏━┓╺┳┓╻ ╻╻  ┏━╸┏━┓        │
# │    ┃┃┃┃ ┃ ┃┃┃ ┃┃  ┣╸ ┗━┓        │
# │    ╹ ╹┗━┛╺┻┛┗━┛┗━╸┗━╸┗━┛        │
# ╰─────────────────────────────────╯

module "network_structure" {
  vsphere_host_id = data.vsphere_host.vs_esx_host.id
  source          = "./modules/network-structure"
}
