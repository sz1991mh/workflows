#!/bin/sh
set -e

_init_config_dir() {

  if [ -d "/etc/surgio" ] && [ ! -f "/etc/surgio/surgio.conf.js" ]; then
    cp -rf /opt/surgio/provider /opt/surgio/template /opt/surgio/surgio.conf.js -t /etc/surgio/
  fi

  ln -sf /opt/surgio/node_modules /etc/surgio/

  (cd /etc/surgio; npm exec -- surgio generate )

}

_init_config_dir



# Run command with node if the first argument contains a "-" or is not a system command. The last
# part inside the "{}" is a workaround for the following bug in ash/dash:
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=874264
if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ] || { [ -f "${1}" ] && ! [ -x "${1}" ]; }; then
  set -- node "$@"
fi

exec "$@"