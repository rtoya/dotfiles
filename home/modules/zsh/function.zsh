# fzf + kubernetes
function ksl() {
  local pod
  pod=$(kubectl get pods --no-headers | fzf --preview 'kubectl logs --tail=50 {1}' | awk '{print $1}')
  if [ -n "$pod" ]; then
    kubectl stern "$pod"
  fi
}
