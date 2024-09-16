all:
 hosts:
%{ for idx, host in vm ~}
   ${host.name}: 
      ansible_host: ${replace(split("/", split(",", host.ipconfig0)[0])[0], "ip=", "")}
%{ endfor ~}

 children:
  pg_servers:
    hosts:
      pgprimary: {}
      pgsecondary: {}

    vars:
      zabbix_agent_server: "{{ zabbix_server }}"
      zabbix_agent_serveractive: "{{ zabbix_serveractive }}"
      zabbix_host_groups:
          - Linux servers
          - PG servers

      zabbix_agent_macros:
          - macro_key: PG.PASSWORD
            macro_value: "{{ zabbix_agent_pg_password }}"
            macro_type: secret
          
          - macro_key: PG.USER
            macro_value: "{{ zabbix_agent_pg_username }}"
            macro_type: text

      zabbix_agent_link_templates:
          - Linux by Zabbix agent
          - PostgreSQL by Zabbix agent 2


  monitors:
    hosts:
      monitor: {}
    
    vars:
      zabbix_agent_server: 127.0.0.1
      zabbix_agent_serveractive: 127.0.0.1
      zabbix_agent_ip: 127.0.0.1

      zabbix_host_groups:
          - Linux servers

      zabbix_agent_link_templates:
          - Linux by Zabbix agent
          - Zabbix server health


  buckets:
    hosts: 
      bucketserver: {}
    vars:
      zabbix_agent_server: "{{ zabbix_server }}"
      zabbix_agent_serveractive: "{{ zabbix_serveractive }}"
      zabbix_host_groups:
          - Linux servers

      zabbix_agent_link_templates:
          - Linux by Zabbix agent

  pgbackrests:
    hosts: 
      pgbackrest: {}
    
    vars:
      zabbix_agent_server: "{{ zabbix_server }}"
      zabbix_agent_serveractive: "{{ zabbix_serveractive }}"
      zabbix_host_groups:
          - Linux servers

      zabbix_agent_link_templates:
          - "Linux by Zabbix agent"
  
 vars:
    zabbix_server: "{{ hostvars['monitor']['ansible_host'] }}"
    zabbix_serveractive: "{{ hostvars['monitor']['ansible_host'] }}"
    ansible_ssh_common_args: '-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
    ansible_python_interpreter=/usr/bin/python3.12
    vault_token: 'hvs.Y5g63HIwkbWGKdQbvmN6gyJb'
    vault_server: 127.0.0.1
    vault_opts:
     url: "https://{{vault_server}}:8200"
     auth_method: token
     token: "{{ vault_token }}"
     engine_mount_point: cometocode-secrets