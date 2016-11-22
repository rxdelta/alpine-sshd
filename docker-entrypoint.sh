#!/usr/bin/env bash

# function that generates random password
genpasswd() {
  local l=$1
  [ "$l" == "" ] && l=20
  tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

mkdir -p /home/sshuser/.commands
allowed_apps=(autossh ssh)

for app in "${allowed_apps[@]}"; do
  location=`which ${app}`
  ln -s ${location} /home/sshuser/.commands/${app}
done
chown -R root:root /home/sshuser/.commands

root_password=`genpasswd`
echo "root:${root_password}" | chpasswd 2>/dev/null
echo "New root password: ${user_password}"

user_password=`genpasswd`
echo "sshuser:${user_password}" | chpasswd 2>/dev/null

echo ${root_password} > /root/ssh-password-root.txt
echo ${user_password} > /root/ssh-password-user.txt
chmod 0400 /root/ssh-password-root.txt
chmod 0400 /root/ssh-password-user.txt

echo "Executing command: $@"

exec "$@"

