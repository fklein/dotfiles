if command -v "kubectl" >/dev/null 2>&1; then
    alias k='kubectl'
    alias kdesc='kubectl describe'
    alias kget='kubectl get'
fi
