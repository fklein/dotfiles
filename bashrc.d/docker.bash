if command -v docker >/dev/null 2>&1; then
    # For the executing the docker commands "sudo" is required,
    # unless we are a member of the "docker" group.
    DOCKERCMD="sudo docker"
    if id -nG | grep -qwF "docker"; then
        DOCKERCMD="docker"
    else
        alias docker="${DOCKERCMD}"
    fi

    alias dk="${DOCKERCMD}"

    # buildx / Manage builds
    alias dkb="${DOCKERCMD} buildx build"

    # container / Manage containers
    alias dkc="${DOCKERCMD} container"
    alias dkcl="${DOCKERCMD} container ls"
    alias dkci="${DOCKERCMD} container inspect"
    alias dkcr="${DOCKERCMD} container run"
    alias dkce="${DOCKERCMD} container exec"
    alias dkcc="${DOCKERCMD} container create"
    alias dkcu="${DOCKERCMD} container update"
    alias dkcs="${DOCKERCMD} container start"
    alias dkcx="${DOCKERCMD} container stop"
    alias dkck="${DOCKERCMD} container kill"
    alias dkcd="${DOCKERCMD} container diff"
    alias dkct="${DOCKERCMD} container top"

    alias dkcsh="_docker_container_exec "sh""
    _docker_container_exec() {
        ${DOCKERCMD} container exec --interactive --tty "${2}" ${1}
    }

    # image / Manage images
    alias dki="${DOCKERCMD} image"
    alias dkil="${DOCKERCMD} image ls"
    alias dkii="${DOCKERCMD} image inspect"
    alias dkih="${DOCKERCMD} image history"
    alias dkip="${DOCKERCMD} image push"
    alias dkit="${DOCKERCMD} image tag"
    alias dkirm="${DOCKERCMD} image rm"

    # network / Manage networks
    alias dkn="${DOCKERCMD} network"
    alias dknl="${DOCKERCMD} network ls"
    alias dkni="${DOCKERCMD} network inspect"
    alias dknc="${DOCKERCMD} network create"
    alias dknr="${DOCKERCMD} network rm"

    # volume / Manage volumes
    alias dkv="${DOCKERCMD} volume"
    alias dkvl="${DOCKERCMD} volume ls"

    # system / Manage Docker
    alias dky="${DOCKERCMD} system"
    alias dkyi="${DOCKERCMD} system info"
    alias dkyp="${DOCKERCMD} system prune"

    # checkpoint / Manage checkpoints
    # context / Manage contexts
    # manifest / Manage Docker image manifests and manifest lists
    # plugin / Manage plugins
    # trust / Manage trust on Docker images

    # compose / Define and run multi-container applications with Docker
    if docker compose >/dev/null 2>&1; then
        alias dc="${DOCKERCMD} compose"
        alias dcu="${DOCKERCMD} compose up"
        alias dcu="$dDOCKERCMD} compose down"
        alias dcu="$dDOCKERCMD} compose build"
        alias dcl="$dDOCKERCMD} compose ls"
    fi

    # swarm / Define and run multi-container applications with Docker
    if docker swarm >/dev/null 2>&1; then
        alias ds="${DOCKERCMD} swarm"
        alias dss="${DOCKERCMD} service"
        alias dsn="${DOCKERCMD} node"
        alias dsx="${DOCKERCMD} secret"
        alias dsss="${DOCKERCMD} stack"
    fi
fi


