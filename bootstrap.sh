#!/bin/bash

SALT="salt-call"
LOCAL_MINION="--local --pillar-root=./pillar --file-root=./salt"

function ensure_dependencies() {
    [[ -f .deps-installed ]] || install_dependencies
}

function install_dependencies() {
    sudo apt-get install -y \
        salt-common \
        python-psutil \
        python-configparser \
        python-msgpack ||
    {
        echo "Error during dependency installation!"
        exit 3
    }
    touch .deps-installed
}

function ensure_synced() {
    [[ -f .all-synced ]] || sync_all
}

function sync_all() {
    sudo $SALT $LOCAL_MINION saltutil.sync_all || {
      echo "Error during salt syncing!"
      exit 4
    }
    touch .all-synced
}

function clean() {
    [[ -f .deps-installed ]] && rm .deps-installed
    [[ -f .all-synced ]] && rm .all-synced
}

MACHINE_ID=""
ACTION="state.highstate"
DEBUG_FLAG="-l info"

while [ "$#" -gt "0" ]; do
    case $1 in
    --id)
        MACHINE_ID="$2"
        shift 2
    ;;
    --debug)
        DEBUG_FLAG="-l trace"
        shift
    ;;
    --sync)
        sync_all
        exit 0
    ;;
    --pillar|--pillars)
        ACTION="pillar.items"
        shift
    ;;
    --grain|--grains)
        ACTION="grains.items"
        shift
    ;;
    --clean)
        clean
        exit 0
    ;;
    *)
        ACTION="state.apply $1"
        shift
    ;;
    esac
done

hash $SALT 2>/dev/null || clean
ensure_dependencies
ensure_synced

if [[ "$MACHINE_ID" == "" ]]; then
    echo "You must provide a machine id via the --id option!"
    exit 2
fi

sudo $SALT $LOCAL_MINION $DEBUG_FLAG --id="$MACHINE_ID" $ACTION
