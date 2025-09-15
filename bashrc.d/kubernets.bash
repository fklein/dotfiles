if command -v kubectl >/dev/null 2>&1; then
    alias kc='kubectl'

    # get / Listing resources
    alias kcg='kubectl get'
    alias kcgp='kubectl get pod'
    alias kcgr='kubectl get replicaset'
    alias kcgd='kubectl get deployment'
    alias kcgs='kubectl get service'
    alias kcgn='kubectl get node'
    alias kcge='kubectl get event'
    alias kcgns='kubectl get namespace'
    alias kcga='kubectl get all'

    # describe / Show resource details
    alias kcd='kubectl describe'
    alias kcdp='kubectl describe pod'
    alias kcdr='kubectl describe replicaset'
    alias kcdd='kubectl describe deployment'
    alias kcds='kubectl describe service'
    alias kcdn='kubectl describe node'
    alias kcda='kubectl describe all'    

    # create / Creating resources
    alias kcc='kubectl create'
    alias kccp='kubectl create pod'
    alias kccr='kubectl create replicaset'
    alias kccd='kubectl create deployment'
    alias kccs='kubectl create service'
    
    # delete / Removing resources
    alias kcx='kubectl delete'
    alias kcxp='kubectl delete pod'
    alias kcxr='kubectl delete replicaset'
    alias kcxd='kubectl delete deployment'
    alias kcxs='kubectl delete service'
    alias kcxn='kubectl delete node'
    
    # edit / Edit resources
    alias kce='kubectl edit'
    alias kcep='kubectl edit pod'
    alias kcer='kubectl edit replicaset'
    alias kced='kubectl edit deployment'
    alias kces='kubectl edit service'
    alias kcen='kubectl edit node'
    
    # scale / Scale resources
    alias kcs='kubectl scale'
    alias kcsr='kubectl scale replicaset'
    alias kcss='kubectl scale statefulset'
    alias kcsd='kubectl scale deployment'

    # scale / Scale resources
    alias kcas='kubectl autoscale'
    alias kcasr='kubectl autoscale replicaset'
    alias kcass='kubectl autoscale statefulset'
    alias kcasd='kubectl autoscale deployment'

    # rollout / Manage resources deployments
    alias kcr='kubectl rollout'
    alias kcrh='kubectl rollout history'
    alias kcrp='kubectl rollout pause'
    alias kcrr='kubectl rollout restart'
    alias kcrc='kubectl rollout resume'
    alias kcrs='kubectl rollout status'
    alias kcru='kubectl rollout undo'

    alias kcexp='kubectl expose'
        
    # YAML file operations
    alias kcapp='kubectl apply'
    alias kcrep='kubectl replace'

    # one off commands
    alias kcrun='kubectl run'
    alias kcexe='kubectl exec'
    alias kcatt='kubectl attach'
    
    alias kctop='kubectl top'
    alias kcdiff='kubectl diff'
    alias kcset='kubectl set'
    
    alias kcev='kubectl events'
    alias kclog='kubectl logs'
fi
