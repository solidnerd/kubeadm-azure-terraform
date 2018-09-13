variable azure {
  type = "map"
}

variable resource_group_name {}
variable location {}
variable master_ip {}
variable subnet_id {}
variable count {}
variable admin_username {}
variable admin_password {}
variable ssh_key {}
variable node_size {}
variable computer_name_prefix {}
variable kubeadm_token {}

variable node_labels {
  type = "list"
}
