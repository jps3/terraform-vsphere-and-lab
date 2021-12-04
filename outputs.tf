output "gateway-ip" {
  value = module.gateway.default-ip
}

output "bastion-ip" {
  value = module.bastion.default-ip
}
