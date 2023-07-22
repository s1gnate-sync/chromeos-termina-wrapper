#!/usr/bin/env bash
# Installs termina wrapper to local bin
set -eux

[ "$(id -u)" = 0 ] || {
  echo "$0: must be superuser"
  exit 1
}

readonly BIN="/usr/local/bin"
readonly DEST="${BIN}/termina"

mkdir -p "${BIN}"
cp "$(dirname ${0})/termina" "${DEST}"
ln -s "${DEST}" "${BIN}/lxc"
chmod a+x "${DEST}"
