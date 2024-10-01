#!/bin/bash
source .env
export SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd -P)"

cd $SCRIPT_DIR
set -o nounset # Exit if the script tries to use undeclared variables
set -o pipefail

# Help function
show_help() {
  echo "Usage: $(basename "$0") [OPTIONS] COMMAND"
  echo ""
  echo "Options:"
  echo "  --clean          Clean build"
  echo "  --help           Show this help message"
  echo ""
  echo "Commands:"
  echo "  docker-build     Build the Docker image"
  echo "  export-org       Generate Hugo Markdown from org files"
}

BUILD_CLEAN=0
# gets flags
for arg in "$@"; do
  case $arg in
    --clean)
      BUILD_CLEAN=1
      ;;
    --help)
      show_help
      exit 0
      ;;
    *)
  esac
done

CMD="docker compose --env-file=${SCRIPT_DIR}/.env -f ${SCRIPT_DIR}/docker-compose.yml"

case $1 in
  "docker-build")
    export DOCKERFILE="${SCRIPT_DIR}/Dockerfile"
    export COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.yml"
    CMD="${CMD} --progress plain build org"
    echo "Building ${DOCKERFILE} using ${COMPOSE_FILE}"
    if [ "${BUILD_CLEAN}" -eq "1" ]; then
      echo 'Build the image cleanly'
      CMD="${CMD} --no-cache"
    fi
    echo $CMD
    eval "${CMD}"
    ;;
  "inspect")
    if [ -z "$2" ]; then
        echo "Error: must select container to inspect"
        exit 1
    else
        CONTAINER_NAME=$2
    fi
    echo "Running $CONTAINER_NAME interactively..."

    FLAGS="-it --rm --no-deps "
    docker compose run $FLAGS ${CONTAINER_NAME} bash
    ;;
  "exec-babel")
    if [ -z "$2" ]; then
        echo "Error: must specify an org file to execute"
        exit 1
    fi
    FILE_PATH="$2"
    CMD="${CMD} run --rm org doomscript .org_out/export.el $FILE_PATH"

    echo "Executing org-babel-execute-buffer on $FILE_PATH"
    eval "${CMD}"
    ;;
  *)
    echo "Invalid operation."
    exit 1
    ;;
esac
