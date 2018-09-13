resource "azurerm_availability_set" "availability_set" {
  name                = "masteras"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  managed             = true
}

resource "azurerm_network_interface" "masternic" {
  name                = "masternic${count.index}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  count               = "${var.count}"

  ip_configuration {
    name                                    = "ipconfiguration${count.index}"
    subnet_id                               = "${var.subnet_id}"
    private_ip_address_allocation           = "dynamic"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.backend_pool.*.id}"]
    load_balancer_inbound_nat_rules_ids     = ["${element(azurerm_lb_nat_rule.ssh.*.id, count.index)}"]
  }
}

resource "azurerm_virtual_machine" "mastervm" {
  name                  = "master${count.index}"
  count                 = "${var.count}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${element(azurerm_network_interface.masternic.*.id, count.index)}"]
  vm_size               = "${var.master_size}"
  availability_set_id   = "${azurerm_availability_set.availability_set.id}"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "master${format("%03d", count.index)}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.computer_name}${count.index}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
    custom_data    = "${data.template_file.cloud-config.rendered}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${file("${var.ssh_key}")}"
    }
  }
}

data "template_file" "cloud-config" {
  template = "${file("${path.root}/templates/bootstrap.sh")}"

  vars {
    SUBSCRIPTION_ID = "${var.azure["subscription_id"]}"
    TENANT_ID       = "${var.azure["tenant_id"]}"
    CLIENT_ID       = "${var.azure["client_id"]}"
    CLIENT_SECRET   = "${var.azure["client_secret"]}"
    LOCATION        = "${var.location}"
    RESOURCE_GROUP  = "${var.resource_group_name}"
    master_ip       = "${var.master_ip}"
    node_labels     = "${join(",", var.node_labels)}"
    admin_username  = "${var.admin_username}"
    kubeadm_token   = "${var.kubeadm_token}"
  }
}
