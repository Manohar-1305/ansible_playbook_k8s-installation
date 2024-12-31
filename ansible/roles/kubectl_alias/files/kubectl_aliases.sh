# Basic kubectl aliases
alias k="kubectl"
alias kga="kubectl get all"
alias kgp="kubectl get pods"
alias kgs="kubectl get svc"
alias kgd="kubectl get deployments"
alias kgn="kubectl get nodes"
alias kd="kubectl describe"
alias kdel="kubectl delete"
alias ka="kubectl apply -f"
alias kl="kubectl logs"

# Namespace-specific commands
alias kgpn="kubectl get pods -n"
alias kdsn="kubectl describe -n"
alias kln="kubectl logs -n"

# Quick actions
alias krestart="kubectl rollout restart deployment"
alias kscale="kubectl scale --replicas"
alias kex="kubectl exec -it"

# Config and context management
alias kcgc="kubectl config get-contexts"
alias kcc="kubectl config current-context"
alias kcu="kubectl config use-context"
alias kcd="kubectl config delete-context"

# Apply, edit, and debug
alias kapply="kubectl apply -f"
alias kedit="kubectl edit"
alias kdebug="kubectl debug"

# Port-forward and proxy
alias kpf="kubectl port-forward"
alias kproxy="kubectl proxy"

# Custom resource definitions (CRDs)
alias kgcrd="kubectl get crd"
alias kdcrd="kubectl describe crd"

# Watch resources
alias kgpwatch="kubectl get pods --watch"
alias kgnwatch="kubectl get nodes --watch"

# Delete with force
alias kdelpod="kubectl delete pod --grace-period=0 --force"
alias kdelns="kubectl delete namespace"

# Logs and troubleshooting
alias klf="kubectl logs -f"  # Follow logs
alias ktop="kubectl top pod"
alias ktopn="kubectl top node"
alias kdebugpod="kubectl exec -it -- /bin/sh"

# Events
alias kevents="kubectl get events --sort-by=.metadata.creationTimestamp"
