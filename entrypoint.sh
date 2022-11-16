#!/bin/bash

proxy() {
  echo "Proxy mode"
  eval $(ssh-agent)
  ssh-add <(echo "$KEY")
  ssh-add -L
  ssh $T_USER \
   -o StrictHostKeyChecking=no \
   -N -L 80:$T_REMOTE \
   -p $T_PORT
}

server() {
  echo "Server mode"
  if [ -n "$AUTHORIZED_KEYS" ]; then
    echo "ENV Authorized Keys set"
    echo "$AUTHORIZED_KEYS" > /etc/ssh/authorized_keys
  elif [ -f /authorized_keys ]; then
    echo "Authorized Keys file mounted"
    cp /authorized_keys /etc/ssh/authorized_keys
  else
    echo "No Authorized Keys"
    exit 1
  fi

  config="
  PermitRootLogin prohibit-password
  PasswordAuthentication no
  AuthorizedKeysFile /etc/ssh/authorized_keys
  PermitOpen ${T_REMOTE:-localhost:80}
  AllowTcpForwarding yes
  X11Forwarding no
  AllowAgentForwarding no
  ForceCommand /bin/false
  "
  echo "$config"
  echo "$config" > /etc/ssh/sshd_config

  chmod 600 /etc/ssh/authorized_keys
  ssh-keygen -A
  /usr/sbin/sshd -D
}

if [ -n "$KEY" ]; then
  # Proxy Mode
  echo "ENV Key set"
  proxy
else
  # Server mode
  server
fi



