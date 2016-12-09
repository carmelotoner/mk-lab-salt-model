#!/bin/bash

FORMULA_PATH=/usr/share/salt-formulas
FORMULA_BRANCH=master

mkdir -p /srv/salt/reclass/classes/service

echo "Configuring salt master formulas ..."

[ ! -d /srv/salt/reclass/classes/service ] && mkdir -p /srv/salt/reclass/classes/service

declare -a formula_services=("linux" "reclass" "salt" "openssh" "ntp" "git" "nginx" "collectd" "sensu" "heka" "sphinx" "keystone" "mysql" "grafana" "haproxy" "horizon" "libvirt" "memcached" "rabbitmq" "keepalived" "glusterfs" "glance" "keystone" "cinder" "nova" "neutron" "heat" "opencontrail" "galera" "redis" "graphite" "postgresql" "apache" "supervisor" "java" "elasticsearch" "kibana" "nagios" "influxdb")


for formula_service in "${formula_services[@]}"; do
  echo -e "\nConfiguring salt formula ${formula_service} ...\n"
  if [[ ! -d "${FORMULA_PATH}/env/_formulas/${formula_service}" ]]; then
    _URL=https://github.com/tcpcloud/salt-formula-${formula_service}.git
    _BRANCH=$FORMULA_BRANCH
    if ! git ls-remote --exit-code --heads $_URL $_BRANCH; then
      # Fallback to the master branch if the branch doesn't exist for this repository
      _BRANCH=master
    fi
    git clone $_URL ${FORMULA_PATH}/env/_formulas/${formula_service} -b $_BRANCH
  fi
  [ ! -L "/usr/share/salt-formulas/env/${formula_service}" ] && \
    ln -s ${FORMULA_PATH}/env/_formulas/${formula_service}/${formula_service} /usr/share/salt-formulas/env/${formula_service}
  [ ! -L "/srv/salt/reclass/classes/service/${formula_service}" ] && \
    ln -s ${FORMULA_PATH}/env/_formulas/${formula_service}/metadata/service /srv/salt/reclass/classes/service/${formula_service}
done
