# 📋 Comandi di Verifica e Test per Kubernetes

| **Obiettivo**                                      | **Comando**                                      | **Output atteso** |
|----------------------------------------------------|--------------------------------------------------|-------------------|
| 📌 **Verificare i nodi nel cluster**              | `kubectl get nodes`                             | `Ready` per ogni nodo |
| 📌 **Verificare i pod di sistema**                | `kubectl get pods -n kube-system`               | Tutti `Running` |
| 📌 **Verificare che la rete funzioni (Flannel)**  | `kubectl get pods -n kube-system | grep flannel` | Pod `Running` |
| 📌 **Verificare il servizio DNS (CoreDNS)**       | `kubectl get pods -n kube-system | grep coredns` | Pod `Running` |
| 📌 **Verificare se i worker hanno aderito**       | `kubectl get nodes`                             | I worker compaiono nella lista |
| 🔧 **Risoluzione problemi: vedere i log di un pod** | `kubectl logs <nome_pod>`                      | Mostra i log del pod |
| 🔧 **Vedere gli eventi del cluster**              | `kubectl get events --sort-by=.metadata.creationTimestamp` | Elenco degli eventi recenti |
| ✅ **Testare un'app semplice (Nginx)**            | `kubectl run test-nginx --image=nginx --restart=Never` | Pod `Running` |
| ✅ **Vedere i pod in esecuzione**                 | `kubectl get pods`                              | Il pod `test-nginx` è `Running` |
| ✅ **Eliminare un pod di test**                   | `kubectl delete pod test-nginx`                 | Pod eliminato |


# 🌐 Come esporre un servizio in Kubernetes

| **Metodo**         | **Quando usarlo** | **Come funziona** | **Comando per crearlo** | **Come accedere** |
|--------------------|------------------|-------------------|-------------------------|-------------------|
| **ClusterIP** (default) | Per servizi interni al cluster | Il servizio è accessibile solo da altri pod nel cluster | `kubectl expose pod myapp --port=80 --target-port=80 --name=myapp-service` | `curl http://myapp-service` (da un altro pod) |
| **NodePort** | Per test locali o accesso da IP del nodo | Espone il servizio su una porta alta (30000-32767) su ogni nodo | `kubectl expose pod myapp --type=NodePort --port=80 --target-port=80 --name=myapp-nodeport` | `http://<IP_DEL_NODO>:<NODE_PORT>` |
| **LoadBalancer** (con MetalLB in bare-metal) | Per avere un IP pubblico o un IP dedicato nella LAN | Assegna un IP esterno al servizio | `kubectl expose pod myapp --type=LoadBalancer --port=80 --target-port=80 --name=myapp-loadbalancer` | `http://<EXTERNAL_IP>` |
| **Ingress** (con Ingress Controller) | Per esposizione HTTP(S) con domini e regole | Usa un proxy come Nginx per gestire il traffico verso più servizi | Configurare un `Ingress` con regole | `http://<DOMINIO_CONFIGURATO>` |




 ansible-playbook -i inventory/inventory.yml playbook.yml --flush-cache -b

