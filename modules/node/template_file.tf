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
