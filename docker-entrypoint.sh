#!/usr/bin/env bash

# function that generates random password
genpasswd() {
  local l=$1
  [ "$l" == "" ] && l=20
  tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

root_password=`genpasswd`
echo "root:${root_password}" | chpasswd 2>/dev/null
echo ${root_password} > /root/ssh-password-root.txt
chmod 0400 /root/ssh-password-root.txt

for user_password in ${SSH_USERHASH_ALL}
do
  user="$(echo "$user_password" | sed 's/^\([^:]*\).*/\1/')"
  echo "Creating restricted user ${user}"
  adduser -D -s  /bin/bash ${user}
  mkdir -p       /home/${user}/.ssh
  chmod 0700     /home/${user}/.ssh
  chown -R ${user}:${user} /home/${user}
  echo "$user_password" | chpasswd
done

exec "$@"
