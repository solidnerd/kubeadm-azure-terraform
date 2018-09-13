output "local_ip_v4" {
  value = ["${azurerm_network_interface.masternic.*.private_ip_address}"]
}
