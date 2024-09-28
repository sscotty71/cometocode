terraform {
  required_version = ">= 1.9.4"

  backend "gcs" {
    bucket      = "terraform-bucket-come2code"
    credentials = ".secrets/scenic-edition-435709-h2-8be0009bf845.json"
  }


  required_providers {

    vault = {
      source  = "hashicorp/vault"
      version = "4.4.0"
    }
      proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc4"  # Usa una versione stabile se disponibile
    }
  }
}

provider "vault" {
  address = "https://127.0.0.1:8200"
  token   = var.VAULT_TOKEN  # Token per l'accesso a Vault
}

data "vault_kv_secret_v2" "proxmox" {
   mount    = "cometocode-secrets"
   name     = "proxmox"
 }
 
data "vault_kv_secret_v2" "proxmox-ssh" {
   mount    = "cometocode-secrets"
   name     = "proxmox-ssh"
 }

provider "proxmox" {
  pm_tls_insecure = true
  pm_debug        = false

  pm_api_url  = data.vault_kv_secret_v2.proxmox.data["pm_api_url"]
  pm_user     = data.vault_kv_secret_v2.proxmox.data["pm_user"]
  pm_password = data.vault_kv_secret_v2.proxmox.data["pm_password"]

 
}