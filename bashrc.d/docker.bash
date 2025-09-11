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

    # builder / Manage builds
    alias dkb="${DOCKERCMD} builder build"
    alias dkbx="${DOCKERCMD} buildx build"

    # container / Manage containers
    alias dkc="${DOCKERCMD} container"
    alias dkcl="${DOCKERCMD} container ls"
    alias dkcc="${DOCKERCMD} container create"
    alias dkci="${DOCKERCMD} container inspect"
    alias dkcx="${DOCKERCMD} container rm"
    alias dkcz="${DOCKERCMD} container prune"
    alias dkcr="${DOCKERCMD} container run"
    alias dkce="${DOCKERCMD} container exec"
    alias dkca="${DOCKERCMD} container attach"
    alias dkcu="${DOCKERCMD} container update"
    alias dkcn="${DOCKERCMD} container rename"
    alias dkcd="${DOCKERCMD} container diff"
    alias dkcw="${DOCKERCMD} container wait"
    alias dkct="${DOCKERCMD} container top"
    alias dkcs="${DOCKERCMD} container start"
    alias dkck="${DOCKERCMD} container kill"
    # subgroup for container status, to avoid conflicts
    alias dkcss="${DOCKERCMD} container start"
    alias dkcsr="${DOCKERCMD} container restart"
    alias dkcsx="${DOCKERCMD} container stop"
    alias dkcsk="${DOCKERCMD} container kill"
    alias dkcsp="${DOCKERCMD} container pause"
    alias dkcsu="${DOCKERCMD} container unpause"
    # subgroup for container info, to avoid conflicts
    alias dkcit="${DOCKERCMD} container top"
    alias dkcil="${DOCKERCMD} container logs"
    alias dkcip="${DOCKERCMD} container port"
    alias dkcis="${DOCKERCMD} container stats"

    alias dkcsh="_docker_container_exec "sh""
    _docker_container_exec() {
        ${DOCKERCMD} container exec --interactive --tty "${2}" ${1}
    }

    # image / Manage images
    alias dki="${DOCKERCMD} image"
    alias dkil="${DOCKERCMD} image ls"
    alias dkii="${DOCKERCMD} image inspect"
    alias dkix="${DOCKERCMD} image rm"
    alias dkiz="${DOCKERCMD} image prune"
    alias dkib="${DOCKERCMD} image build"
    alias dkih="${DOCKERCMD} image history"
    alias dkit="${DOCKERCMD} image tag"
    alias dkip="${DOCKERCMD} image push"
    alias dkid="${DOCKERCMD} image pull"

    # network / Manage networks
    alias dkn="${DOCKERCMD} network"
    alias dknl="${DOCKERCMD} network ls"
    alias dknc="${DOCKERCMD} network create"
    alias dkni="${DOCKERCMD} network inspect"
    alias dknx="${DOCKERCMD} network rm"
    alias dknz="${DOCKERCMD} network prune"
    alias dkncon="${DOCKERCMD} network connect"
    alias dkndis="${DOCKERCMD} network disconnect"

    # volume / Manage volumes
    alias dkv="${DOCKERCMD} volume"
    alias dkvl="${DOCKERCMD} volume ls"
    alias dkvc="${DOCKERCMD} volume create"
    alias dkvi="${DOCKERCMD} volume inspect"
    alias dkvx="${DOCKERCMD} volume rm"
    alias dkvz="${DOCKERCMD} volume prune"

    # system / Manage Docker
    alias dky="${DOCKERCMD} system"
    alias dkye="${DOCKERCMD} system events"
    alias dkyi="${DOCKERCMD} system info"
    alias dkyz="${DOCKERCMD} system prune"

    # checkpoint / Manage checkpoints
    alias dkchk="${DOCKERCMD} checkpoint"

    # context / Manage contexts
    alias dkctx="${DOCKERCMD} context"
    
    # manifest / Manage Docker image manifests and manifest lists
    alias dkm="${DOCKERCMD} manifest"

    # plugin / Manage plugins
    alias dkp="${DOCKERCMD} plugin"

    # trust / Manage trust on Docker images
    alias dkt="${DOCKERCMD} trust"

    # compose / Define and run multi-container applications with Docker
    if docker compose >/dev/null 2>&1; then
        alias dc="${DOCKERCMD} compose"
        alias dcu="${DOCKERCMD} compose up"
        alias dcd="${DOCKERCMD} compose down"
        alias dcb="${DOCKERCMD} compose build"
        alias dcc="${DOCKERCMD} compose create"
        alias dcl="${DOCKERCMD} compose ls"
        alias dce="${DOCKERCMD} compose exec"
        alias dci="${DOCKERCMD} compose images"
        alias dcx="${DOCKERCMD} compose rm"
        alias dct="${DOCKERCMD} compose top"
        alias dcv="${DOCKERCMD} compose volumes"
        alias dca="${DOCKERCMD} compose attach"
        
    fi

    # swarm / Define and run multi-container applications with Docker
    if docker swarm >/dev/null 2>&1; then
        alias ds="${DOCKERCMD} swarm"

        # service / Manage services
        alias dss="${DOCKERCMD} service"
        alias dssl="${DOCKERCMD} service ls"
        alias dssc="${DOCKERCMD} service create"
        alias dssi="${DOCKERCMD} service inspect"
        alias dssx="${DOCKERCMD} service rm"
        alias dssu="${DOCKERCMD} service update"
        alias dsss="${DOCKERCMD} service scale"
        alias dssr="${DOCKERCMD} service rollback"
        alias dssp="${DOCKERCMD} service ps"
        alias dssil="${DOCKERCMD} service logs"

        # node / Manage nodes
        alias dsn="${DOCKERCMD} node"
        alias dsnl="${DOCKERCMD} node ls"
        alias dsni="${DOCKERCMD} node inspect"
        alias dsnx="${DOCKERCMD} node rm"
        alias dsnu="${DOCKERCMD} node update"
        alias dsnp="${DOCKERCMD} node ps"
        alias dsnw="${DOCKERCMD} node demote"
        alias dsnm="${DOCKERCMD} node promote"

        # secret / Manage secrets
        alias dsx="${DOCKERCMD} secret"
        alias dsxl="${DOCKERCMD} secret ls"
        alias dsxc="${DOCKERCMD} secret create"
        alias dsxi="${DOCKERCMD} secret inspect"
        alias dsxx="${DOCKERCMD} secret rm"


        # stack / Manage stacks
        alias dss="${DOCKERCMD} stack"
        alias dssl="${DOCKERCMD} stack ls"
        alias dssx="${DOCKERCMD} stack rm"
        alias dssp="${DOCKERCMD} stack ps"
        alias dssd="${DOCKERCMD} stack deploy"
        alias dsss="${DOCKERCMD} stack services"
        alias dssc="${DOCKERCMD} stack config"
    fi
fi


