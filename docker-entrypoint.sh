#!/usr/bin/env bash

# function that generates random password
genpasswd() {
  local l=$1
  [ "$l" == "" ] && l=20
  tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

root_password=`genpasswd`
echo "root:${root_password}" | chpasswd 2>/dev/null
echo "New root password: ${user_password}"
echo ${root_password} > /root/ssh-password-root.txt
chmod 0400 /root/ssh-password-root.txt

for user in ${SSHUSERS}
do
  echo "Creating restricted user ${user}"
  adduser -D -s  /usr/bin/lshell ${user}
  mkdir -p       /home/${user}/.ssh
  chmod 0700     /home/${user}/.ssh
  chown -R ${user}:${user} /home/${user}

  user_password=`genpasswd`
  echo "${user}:${user_password}" | chpasswd 2>/dev/null

  echo ${user_password} > /root/ssh-password-${user}.txt
  chmod 0400 /root/ssh-password-${user}.txt
done

echo "Executing command: $@"

exec "$@"
