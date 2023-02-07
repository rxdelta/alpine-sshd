# vim:set ft=dockerfile:
FROM alpine:latest

LABEL maintainer="Mostafa Nazari <rxdelta@github,gmail,twitter,...>"

RUN apk --update add \
      bash \
      openssh \
&&  rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# cleanup motd
RUN echo "" > /etc/motd

# generate ssh keys
RUN ssh-keygen -f   /etc/ssh/ssh_host_rsa_key     -N '' -t rsa     \
&&  ssh-keygen -f   /etc/ssh/ssh_host_dsa_key     -N '' -t dsa     \
&&  ssh-keygen -f   /etc/ssh/ssh_host_ecdsa_key   -N '' -t ecdsa   \
&&  ssh-keygen -f   /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519 \
&&  cp -a /etc/ssh  /etc/ssh.default

RUN chown root:root /etc/ssh  \
&&  chmod 0600      /etc/ssh/* \
&&  mkdir -p        /root/.ssh \
&&  chmod 0700      /root/.ssh

EXPOSE 22

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN ln -s /docker-entrypoint.sh /create-users

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
