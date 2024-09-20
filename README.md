# Appunti

Qui di seguito trovi alcuni appunti e linee guida che, pur non essendo esaustivi, spero possano tornare utili in qualche modo

## Setup di un Template con Cloud-Init

[Documentazione ufficiale Proxmox Cloud-Init](https://pve.proxmox.com/wiki/Cloud-Init_Support)

Per configurare correttamente un template Proxmox con Cloud-Init, segui questi passaggi:

###  Step1

1. Installare il sistema operativo
2. Creare un utente, ad esempio `ubuntu` 
3. Copiare in authorized_keys, la chiave pubblica poi utilizzata da terraform tramite il remote-exec
4. In sudo aggiungere le seguenti regole: terraform ALL=(ALL) NOPASSWD:ALL


###  Step2

Aggiornare il sisteme e installare cloud-init
 
```
sudo apt update && sudo apt upgrade -y
sudo apt install cloud-init -y
```
 
### 4. Eseguire la pulizia della VM per prepararla all'uso come template
 
```
sudo rm -rf /etc/ssh/ssh_host_*
sudo cloud-init clean
```
 
### 5. Configurazione
In ambiente ubuntu

- Modificare il file /etc/netplan/00-installer-config.yaml

```
network:
  version: 2
  ethernets:
    ens18:
      dhcp4: true
 ```

### 6. Verificare la presenza di nocloud 
Nel file /etc/cloud/cloud.cfg.d/90_dpkg.cfg verificare la presenza di NoCloud e ConfigDrive

```
datasource_list: [ NoCloud, ConfigDrive, OpenStack....]
 ```

### 7. In ambiente Proxmox

Andiamo a creare un ruolo, un utente e andiamo configurare le ACL.

Poi le informazioni sensibili: host, username e password le andremo a memorizzare in vault


Dalla console:

 ```
pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"

pveum user add terraform-prov@pve --password 7yVJLPZxaU3DgPXW

pveum aclmod / -user terraform-prov@pve -role TerraformProv
 ```

## Console con il software necessario

Su una vm: **ubuntu 24.04 lts**

Ad oggi le versioni installate sulle nostre macchine 

|Software |Versione |
|--|--|
| Terraform | 1.9.5-1  |
|  Vault| 1.17.5-1 |
| Ansible core | 2.16.3-0ubuntu2  |



### Installazion Terraform e Vault
 
Con l'utente personale, dalla console


```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

sudo echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install terraform vault

```


verificare che il servizio è up:

```
sudo systemctl status vault
```

In caso avviare il servizio e impostarlo enable

```
 cometocode$ sudo systemctl start vault
 cometocode$ sudo systemctl enable vault
```

Come utente personale "non root" esportare queste due variabili.

```
export VAULT_ADDR='https://127.0.0.1:8200' 
export VAULT_SKIP_VERIFY=true
```

Normalmente il servizio è in ascolto su: 0.0.0.0:8200

Per verificare la configurazione

```
cometocode$ cat /etc/vault.d/vault.hcl 
```

Se tutto è andato bene, dovremmo poter conttare il server con il comando **vault status**


```
cometocode$ vault status


Key                Value
---                -----
Seal Type          shamir
Initialized        false
Sealed             true
Total Shares       0
Threshold          0
Unseal Progress    0/0
Unseal Nonce       n/a
Version            1.17.5
Build Date         2024-08-30T15:54:57Z
Storage Type       file
HA Enabled         false
```

Dopo aver sbloccato (unseal) e inizializzato Vault, ed eseguito tutte le configurazioni necessarie...
[Documentazione ufficiale Vault](https://developer.hashicorp.com/vault/docs)

#### Accedo a Vault tramite l'autenticazione

```
cometocode$ vault login hvs.RxvvGuNO0b02dR772TVwO6Vb
```

#### Creo il secrets per kv2 con path  cometocode-secrets

```
vault secrets enable -path=cometocode-secrets -version=2 kv
```

#### Inserisco i secrets necessari per terraform e ansible

```
vault kv put cometocode-secrets/proxmox pm_api_url="https://192.168.173.91:8006/api2/json" pm_user="terraform-prov@pve" pm_password="7yVJLPZxaU3DgPXW"

vault kv put cometocode-secrets/zabbix_server dbname="zabbix" dbuser="zabbix" dbpassword="v36dhUSV-RGUuCbFGkM"

vault kv put cometocode-secrets/zabbix_agent_pg_user username="zbx_monitor" password="c3bkne,bZjrcBGwrHQN"
```


#### Genero un token temporaneo valido per un'ora per eseguire le attività


```
vault token create -policy="read-only-cometocode-secrets" -policy="token-policy"   -ttl=1h  -explicit-max-ttl=1h
```

#### Terraform e Vault che lavorano insieme

Ora con Terraform possiamo usare il token appena generato

```
cometocode$ terraform init

cometocode$ terraform plan -var="VAULT_TOKEN=vs.ESIKT0k6zo..."

cometocode$ terraform apply -var="VAULT_TOKEN=vs.ESIKT0k6zo..."

cometocode$ terraform destroy -var="VAULT_TOKEN=vs.ESIKT0k6zo..."
```


### Installazion Ansible

Dalla shell 

```
cometocode$ sudo apt update
cometocode$ sudo apt upgrade 
cometocode$ sudo apt install ansible-core
 ```


Per lavorare con Vault abbiamo bisogno delle librerie hvac

 ```
cometocode$ sudo apt install python3-hvac
 ```

Con utente personale non di root
 
```
cometocode$  ansible-galaxy collection list | grep zabbix

community.zabbix                         2.3.1  
 ```


Forziamo l'installazione della collezione community.zabbix 3.1.2  

 ```
cometocode$ ansible-galaxy collection install community.zabbix --force

community.zabbix                         3.1.2  

 ```

Sono stati utilizzati dele role per la gestione di postsgresql, apache e php

```
git clone https://github.com/geerlingguy/ansible-role-postgresql.git
git clone https://github.com/geerlingguy/ansible-role-php.git
git clone https://github.com/geerlingguy/ansible-role-apache.git
```

Infine lanciamo ansible 

```
cometocode$ ansible-playbook -i inventory.yml ansible/zabbix-server-pg.yml -u stefano -b --extra-vars "vault_token=hvs.ESIKT0k6zo..."
cometocode$ ansible-playbook -i inventory.yml ansible/zabbix-agent.yml -u stefano -b --extra-vars "vault_token=hvs.ESIKT0k6zo..."

```