#!/bin/bash

set -e
[ "$DEBUG" == "true" ] && env && set -x

DAEMON=sshd

USER=frontline
HOME=$ROOT_PATH/home/probe

# Check if an authorized_keys file was provided in environment
if [ -z "$AUTHORIZED_KEYS_FILE" ]; then
  echo "ERROR: Environment variable AUTHORIZED_KEYS_FILE should not be empty."
  exit 1
fi

IS_KUBERNETES=false
# Create a frontline user with current uid if needed
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "$USER:x:$(id -u):0::$HOME:/bin/bash" >> /etc/passwd
  fi
else
  IS_KUBERNETES=true
  useradd --home $HOME --password fake_password --shell /bin/bash $USER
fi

# Add authorized keys to current ssh environment
mkdir -p $HOME/.ssh && chmod 700 $HOME/.ssh
echo "$AUTHORIZED_KEYS_FILE" > $HOME/.ssh/authorized_keys
chmod 644 $HOME/.ssh/authorized_keys

# Generate Host keys, if required
if ! ls $HOME/.ssh/ssh_host_* 1 > /dev/null 2>&1; then
  ssh-keygen -t rsa -b 4096 -N "" -f $ROOT_PATH/etc/ssh/ssh_host_rsa_key > /dev/null 2>&1
  ssh-keygen -t ecdsa -b 521 -N "" -f $ROOT_PATH/etc/ssh/ssh_host_ecdsa_key > /dev/null 2>&1
  ssh-keygen -t ed25519 -N "" -f $ROOT_PATH/etc/ssh/ssh_host_ed25519_key > /dev/null 2>&1
fi

if [[ "$IS_KUBERNETES" = true ]] ; then
  chown -R frontline:frontline $ROOT_PATH
fi

exec "$@"
