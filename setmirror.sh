#!/usr/bin/env bash
#
# Tested OS Distros:
#
# - Ubuntu 14.04/16.04
# - CentOS 6/7
#

set -e

function usage() {
    cat <<EOF
Usage: $(basename $0) <mirror_url>

Examples:

    $(basename $0) https://registry-mirror.qiniu.com

EOF
}

function exit_on_unsupported_os() {
    echo "error: unsupporeted os, can't configure docker --registry-mirror automatically, please refer https://docs.docker.com/registry/recipes/mirror/ docs to configure it manually"
    exit 1
}

function exit_on_success() {
	echo "Success. $1"
	exit 0
}

if [ -z "$1" ]; then
    echo "error: please specify mirror url"
    usage
    exit 1
fi

if [[ ! "$1" =~ (https?)://[-A-Za-z0-9\+_.]*[-A-Za-z0-9\+_] ]]; then
    echo "error: '$1' is not a valid url"
    usage
    exit 1
fi

MIRROR_URL=$1

# Get linux distribution and release version.
LINUX_DIST=
LINUX_DIST_VERSION=

if which lsb_release &>/dev/null; then
    LINUX_DIST="$(lsb_release -si)"
    LINUX_DIST_VERSION="$(lsb_release -rs)"
fi

if [ -z "$LINUX_DIST" ] && [ -r /etc/lsb-release ]; then
    LINUX_DIST="$(. /etc/lsb-release && echo "$DISTRIB_ID")"
    LINUX_DIST_VERSION="$(. /etc/lsb-release && echo "$DISTRIB_RELEASE")"
fi

if [ -z "$LINUX_DIST" ] && [ -r /etc/debian_version ]; then
    LINUX_DIST='Debian'
fi

if [ -z "$LINUX_DIST" ] && [ -r /etc/fedora-release ]; then
    LINUX_DIST='Fedora'
fi

if [ -z "$LINUX_DIST" ] && [ -r /etc/centos-release ]; then
    LINUX_DIST='CentOS'
    LINUX_DIST_VERSION=$(cat /etc/centos-release | grep -o -P '\d+\.\d+\.\d+')
fi

if [ -z "$LINUX_DIST" ] && [ -r /etc/redhat-release ]; then
    LINUX_DIST="$(cat /etc/redhat-release | head -n1 | cut -d " " -f1)"
fi

if [ -z "$LINUX_DIST" ] && [ -r /etc/os-release ]; then
    LINUX_DIST="$(. /etc/os-release && echo "$ID")"
    LINUX_DIST_VERSION="$(. /etc/os-release && echo "$VERSION_ID")"
fi

if [ -z "$LINUX_DIST" ]; then
    exit_on_unsupported_os
fi

# Get docker version.
DOCKER_VERSION=
DOCKER_VERSION_MAJOR=
DOCKER_VERSION_MINOR=
if which docker &>/dev/null; then
    DOCKER_VERSION=$(docker -v | grep -o -P '\d+\.\d+\.\d+')
    DOCKER_VERSION_MAJOR=$(echo $DOCKER_VERSION | cut -d "." -f 1)
    DOCKER_VERSION_MINOR=$(echo $DOCKER_VERSION | cut -d "." -f 2)
else
    echo "error: docker is not installed, please install it first"
    exit 1
fi

if [ "$DOCKER_VERSION_MAJOR" -eq 1 ] && [ "$DOCKER_VERSION_MINOR" -lt 9 ]; then
    echo "error: please upgrade your docker to v1.9 or later"
    exit 1
fi

echo "Linux distribution: $LINUX_DIST $LINUX_DIST_VERSION"
echo "Docker version: $DOCKER_VERSION"
echo "Configuring --registry-mirror=$MIRROR_URL for your docker install."

function is_daemon_json_supported() {
	if [ "$DOCKER_VERSION_MAJOR" -eq 1 ] && [ "$DOCKER_VERSION_MINOR" -lt 12 ]; then
		return 1
	else
		return 0
	fi
}

function update_daemon_json_file() {
    DOCKER_DAEMON_JSON_FILE="/etc/docker/daemon.json"
    if sudo test -f ${DOCKER_DAEMON_JSON_FILE}; then
        sudo cp  ${DOCKER_DAEMON_JSON_FILE} "${DOCKER_DAEMON_JSON_FILE}.bak"
        if sudo grep -q registry-mirrors "${DOCKER_DAEMON_JSON_FILE}.bak";then
            sudo cat "${DOCKER_DAEMON_JSON_FILE}.bak" | sed -n "1h;1"'!'"H;\${g;s|\"registry-mirrors\":\s*\[[^]]*\]|\"registry-mirrors\": [\"${MIRROR_URL}\"]|g;p;}" | sudo tee ${DOCKER_DAEMON_JSON_FILE}
        else
            sudo cat "${DOCKER_DAEMON_JSON_FILE}.bak" | sed -n "s|{|{\"registry-mirrors\": [\"${MIRROR_URL}\"],|g;p;" | sudo tee ${DOCKER_DAEMON_JSON_FILE}
        fi
    else
        sudo mkdir -p "/etc/docker"
        sudo echo "{\"registry-mirrors\": [\"${MIRROR_URL}\"]}" | sudo tee ${DOCKER_DAEMON_JSON_FILE}
    fi
}

# Configure.
case "$LINUX_DIST" in
    CentOS)
        MAJOR=$(echo ${LINUX_DIST_VERSION} | cut -d "." -f1)
        if [ "$MAJOR" -eq 6 ]; then
            DOCKER_SERVICE_FILE="/etc/sysconfig/docker"
            sudo cp ${DOCKER_SERVICE_FILE} "${DOCKER_SERVICE_FILE}.bak"
            sudo sed -i "s|other_args=\"|other_args=\"--registry-mirror='${MIRROR_URL}'|g" ${DOCKER_SERVICE_FILE}
            sudo sed -i "s|OPTIONS='|OPTIONS='--registry-mirror='${MIRROR_URL}'|g" ${DOCKER_SERVICE_FILE}
            exit_on_success "You need to restart docker to take effect: sudo service docker restart"
        elif [ $MAJOR -ge 7 ]; then
            if is_daemon_json_supported; then
                update_daemon_json_file
            else
                DOCKER_SERVICE_FILE="/lib/systemd/system/docker.service"
                sudo cp ${DOCKER_SERVICE_FILE} "${DOCKER_SERVICE_FILE}.bak"
                sudo sed -i "s|\(ExecStart=/usr/bin/docker[^ ]* daemon\)|\1 --registry-mirror="${MIRROR_URL}"|g" ${DOCKER_SERVICE_FILE}
                sudo systemctl daemon-reload
            fi
            exit_on_success "You need to restart docker to take effect: sudo systemctl restart docker "
        else
            exit_on_unsupported_os
        fi
        break
        ;;
    Fedora)
        if is_daemon_json_supported; then
            update_daemon_json_file
        else
            DOCKER_SERVICE_FILE="/lib/systemd/system/docker.service"
            sudo cp ${DOCKER_SERVICE_FILE} "${DOCKER_SERVICE_FILE}.bak"
            sudo sed -i "s|\(ExecStart=/usr/bin/docker[^ ]* daemon\)|\1 --registry-mirror="${MIRROR_URL}"|g" ${DOCKER_SERVICE_FILE}
            sudo systemctl daemon-reload
        fi
        exit_on_success "You need to restart docker to take effect: sudo systemctl restart docker"
        ;;
    Ubuntu)
        MAJOR=$(echo ${LINUX_DIST_VERSION} | cut -d "." -f1)
        if [ "$MAJOR" -ge 16 ]; then
            if is_daemon_json_supported; then
                update_daemon_json_file
            else
                DOCKER_SERVICE_FILE="/lib/systemd/system/docker.service"
                sudo cp ${DOCKER_SERVICE_FILE} "${DOCKER_SERVICE_FILE}.bak"
                sudo sed -i "s|\(ExecStart=/usr/bin/docker[^ ]* daemon -H fd://$\)|\1 --registry-mirror="${MIRROR_URL}"|g" ${DOCKER_SERVICE_FILE}
                sudo systemctl daemon-reload
            fi
            exit_on_success "You need to restart docker to take effect: sudo systemctl restart docker.service"
        else
            if is_daemon_json_supported; then
                update_daemon_json_file
            else
                DOCKER_SERVICE_FILE="/etc/default/docker"
                sudo cp ${DOCKER_SERVICE_FILE} "${DOCKER_SERVICE_FILE}.bak"
                if grep "registry-mirror" ${DOCKER_SERVICE_FILE} > /dev/null; then
                    sudo sed -i -u -E "s#--registry-mirror='?((http|https)://)?[a-zA-Z0-9.]+'?#--registry-mirror='${MIRROR_URL}'#g" ${DOCKER_SERVICE_FILE}
                else
                    echo 'DOCKER_OPTS="$DOCKER_OPTS --registry-mirror='${MIRROR_URL}'"' >> ${DOCKER_SERVICE_FILE}
                fi
            fi
        fi
        exit_on_success "You need to restart docker to take effect: sudo service docker restart"
        ;;
    Debian)
        if is_daemon_json_supported; then
            update_daemon_json_file
        else
            DOCKER_SERVICE_FILE="/etc/default/docker"
            sudo cp ${DOCKER_SERVICE_FILE} "${DOCKER_SERVICE_FILE}.bak"
            if grep "registry-mirror" ${DOCKER_SERVICE_FILE} > /dev/null; then
                sudo sed -i -u -E "s#--registry-mirror='?((http|https)://)?[a-zA-Z0-9.]+'?#--registry-mirror='${MIRROR_URL}'#g" ${DOCKER_SERVICE_FILE}
            else
                echo 'DOCKER_OPTS="$DOCKER_OPTS --registry-mirror='${MIRROR_URL}'"' >> ${DOCKER_SERVICE_FILE}
                echo ${MIRROR_URL}
            fi
        fi
        exit_on_success "You need to restart docker to take effect: sudo service docker restart"
        ;;
    Arch)
        if grep "Arch Linux" /etc/os-release > /dev/null; then
            if is_daemon_json_supported; then
                update_daemon_json_file
            else
                DOCKER_SERVICE_FILE="/lib/systemd/system/docker.service"
                sudo cp ${DOCKER_SERVICE_FILE} "${DOCKER_SERVICE_FILE}.bak"
                sudo sed -i "s|\(ExecStart=/usr/bin/docker[^ ]* daemon -H fd://\)|\1 --registry-mirror="${MIRROR_URL}"|g" ${DOCKER_SERVICE_FILE}
                sudo systemctl daemon-reload
            fi
            exit_on_success "You need to restart docker to take effect: sudo systemctl restart docker"
        else
            exit_on_unsupported_os
        fi
        ;;
    Suse)
        if grep "openSUSE Leap" /etc/os-release > /dev/null; then
            if is_daemon_json_supported; then
                update_daemon_json_file
            else
                DOCKER_SERVICE_FILE="/usr/lib/systemd/system/docker.service"
                sudo cp ${DOCKER_SERVICE_FILE} "${DOCKER_SERVICE_FILE}.bak"
                sudo sed -i "s|\(^ExecStart=/usr/bin/docker daemon -H fd://\)|\1 --registry-mirror="${MIRROR_URL}"|g" ${DOCKER_SERVICE_FILE}
                sudo systemctl daemon-reload
            fi
            exit_on_success "You need to restart docker to take effect: sudo systemctl restart docker"
        else
            exit_on_unsupported_os
        fi
        ;;
    *)
        exit_on_unsupported_os
        ;;
esac
