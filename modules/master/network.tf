resource "azurerm_public_ip" "masterpip" {
  name                         = "masterpip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "Static"
  domain_name_label            = "${var.resource_group_name}"
}
