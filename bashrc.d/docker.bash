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
    alias dkcp="${DOCKERCMD} container port"
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

    alias dkcsh="_docker_container_exec \"sh\""
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
    alias dks="${DOCKERCMD} system"
    alias dkse="${DOCKERCMD} system events"
    alias dksi="${DOCKERCMD} system info"
    alias dksz="${DOCKERCMD} system prune"

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
    if command docker compose >/dev/null 2>&1; then
        alias dc="${DOCKERCMD} compose"

        alias dcu="${DOCKERCMD} compose up"
        alias dcd="${DOCKERCMD} compose down"
        alias dcl="${DOCKERCMD} compose ls"
        alias dcb="${DOCKERCMD} compose build"
        alias dcc="${DOCKERCMD} compose create"
        alias dcx="${DOCKERCMD} compose rm"
        alias dcr="${DOCKERCMD} compose run"
        alias dce="${DOCKERCMD} compose exec"
        alias dca="${DOCKERCMD} compose attach"
        alias dci="${DOCKERCMD} compose images"
        alias dcv="${DOCKERCMD} compose volumes"
        alias dct="${DOCKERCMD} compose top"
        alias dcp="${DOCKERCMD} compose ps"
        alias dcw="${DOCKERCMD} compose watch"
        alias dcs="${DOCKERCMD} compose scale"
        # subgroup for service status, to avoid conflicts
        alias dcss="${DOCKERCMD} compose start"
        alias dcsr="${DOCKERCMD} compose restart"
        alias dcsx="${DOCKERCMD} compose stop"
        alias dcsk="${DOCKERCMD} compose kill"
        alias dcsp="${DOCKERCMD} compose pause"
        alias dcsu="${DOCKERCMD} compose unpause"
        alias dcsw="${DOCKERCMD} compose wait"
        # subgroup for service info, to avoid conflicts
        alias dcil="${DOCKERCMD} compose logs"
        alias dcip="${DOCKERCMD} compose port"
        alias dcis="${DOCKERCMD} compose stats"
        alias dcie="${DOCKERCMD} compose events"
        alias dciv="${DOCKERCMD} compose version"
    fi

    # swarm / Define and run multi-container applications with Docker
    if command docker swarm >/dev/null 2>&1; then
        alias ds="${DOCKERCMD} swarm"

        # service / Manage Swarm services
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

        # node / Manage Swarm nodes
        alias dsn="${DOCKERCMD} node"
        alias dsnl="${DOCKERCMD} node ls"
        alias dsni="${DOCKERCMD} node inspect"
        alias dsnx="${DOCKERCMD} node rm"
        alias dsnu="${DOCKERCMD} node update"
        alias dsnp="${DOCKERCMD} node ps"
        alias dsnw="${DOCKERCMD} node demote"
        alias dsnm="${DOCKERCMD} node promote"

        # secret / Manage Swarm secrets
        alias dsx="${DOCKERCMD} secret"
        alias dsxl="${DOCKERCMD} secret ls"
        alias dsxc="${DOCKERCMD} secret create"
        alias dsxi="${DOCKERCMD} secret inspect"
        alias dsxx="${DOCKERCMD} secret rm"
        alias dsxci='read -p "Name: " sname && read -sp "Value: " sval && echo && ${DOCKERCMD} secret create "${sname}" - <<< ${sval} ; unset sname sval'

        # stack / Manage SWarm stacks
        alias dst="${DOCKERCMD} stack"
        alias dstl="${DOCKERCMD} stack ls"
        alias dstx="${DOCKERCMD} stack rm"
        alias dstp="${DOCKERCMD} stack ps"
        alias dstd="${DOCKERCMD} stack deploy"
        alias dsts="${DOCKERCMD} stack services"
        alias dstc="${DOCKERCMD} stack config"
    fi
fi


