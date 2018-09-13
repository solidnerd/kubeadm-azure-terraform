variable azure {
  type = "map"
}

variable resource_group_name {}
variable count {}
variable location {}
variable master_ip {}
variable subnet_id {}
variable admin_username {}
variable admin_password {}
variable computer_name {}
variable ssh_key {}
variable master_size {}
variable kubeadm_token {}

variable node_labels {
  type = "list"
}
