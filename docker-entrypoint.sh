#!/bin/sh

# function that generates random password
genpasswd() {
  local l=$1
  [ "$l" == "" ] && l=20
  tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

password=`genpasswd`
echo "root:${password}" | chpasswd 2>/dev/null

echo "New root password: ${password}"

echo "Executing command: $@"

exec "$@"

