# vim:set ft=dockerfile:
FROM gliderlabs/alpine:edge

MAINTAINER Andrius Kairiukstis <andrius@kairiukstis.com>

RUN apk --update add openssh rsync \
&&  apk add autossh --update-cache --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
&&  rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key     -N '' -t rsa \
&&  ssh-keygen -f /etc/ssh/ssh_host_dsa_key     -N '' -t dsa \
&&  ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key   -N '' -t ecdsa \
&&  ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519

RUN cp -a /etc/ssh /etc/ssh.default \
&&  mkdir -p /root/.ssh \
&&  chmod 0700 /root/.ssh

COPY ssh_config     /etc/ssh/ssh_config
COPY sshd_config    /etc/ssh/sshd_config

RUN chown root:root /etc/ssh/ssh_config \
&&  chmod 0600      /etc/ssh/ssh_config \
&&  chown root:root /etc/ssh/sshd_config \
&&  chmod 0600      /etc/ssh/sshd_config

EXPOSE 22

ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]

