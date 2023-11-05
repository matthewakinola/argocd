1. kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-ext
2. kubectl get secret --namespace default grafana -o yaml
3. kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
4. kubectl get svc prometheus-server-ext -o jsonpath='{.spec.type}'
5. kubectl get svc prometheus-server-ext -o jsonpath='{.spec.ports[0].nodePort}'
6. kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}'
7. kubectl logs -f <pod-name> -n <namespace>
8. kubectl logs -f <pod-name> -c <container-name> -n <namespace>
9. kubectl get pods --all-namespaces -o json
10. kubectl port-forward service/grafana 8080:80 -n grafana
9. f0c79aeccb493ce4381bea2e514c7ab69d24cf8f7dcb1de69547f8d436f28dc4



#ARGOCD INSTALLATION AND CHEAT SHEET
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get services -n argocd
kubectl port-forward service/argocd-server -n argocd 8080:443
#GET CREDENTIALS
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
#ARGOCD CLI INSTALLATION
brew install argocd
kubectl port-forward svc/argocd-server -n argocd 8080:443
argocd login 127.0.0.1:8080
#create an app
argocd app create webapp-kustom-prod \
--repo https://github.com/devopsjourney1/argo-examples.git \
--path kustom-webapp/overlays/prod --dest-server https://kubernetes.default.svc \
--dest-namespace prod
#cheat sheet
argocd app create #Create a new Argo CD application.
argocd app list #List all applications in Argo CD.
argocd app logs <appname> #Get the application’s log output.
argocd app get <appname> #Get information about an Argo CD application.
argocd app diff <appname> #Compare the application’s configuration to its source repository.
argocd app sync <appname> #Synchronize the application with its source repository.
argocd app history <appname> #Get information about an Argo CD application.
argocd app rollback <appname> #Rollback to a previous version
argocd app set <appname> #Set the application’s configuration.
argocd app delete <appname> #Delete an Argo CD application.