#!/bin/sh

mkdir -p sshuser/.ssh

cd sshuser/.ssh
rm -rf id_rsa id_rsa.pub
ssh-keygen -b 2048 -t rsa -f id_rsa -P '' -C 'Sample ssh key'
cp id_rsa.pub authorized_keys
cd ../..

