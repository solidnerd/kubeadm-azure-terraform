terraform {
  backend "s3" {
    bucket         = "bee42-trainings-machines-state"
    key            = "terraform-infrastructure-azure-kubeadm.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "bee42-trainings-machines-state-lock"
  }
}
