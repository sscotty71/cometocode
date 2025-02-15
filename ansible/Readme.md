 ansible-playbook -i inventory/inventory.yml prometheus/playbook.yml --flush-cache -b
  ansible-playbook -i inventory/inventory.yml  k8s/playbook.yml --flush-cache -b