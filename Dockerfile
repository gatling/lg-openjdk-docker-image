FROM openjdk:8u181-jdk-slim

ENV ROOT_PATH /opt/frontline/probe

RUN apt-get update && \
    apt-get install -y bash net-tools openssh-server && \
    mkdir -p ${ROOT_PATH} \
             ${ROOT_PATH}/bin \
             ${ROOT_PATH}/etc/ssh \
             ${ROOT_PATH}/home \
             ${ROOT_PATH}/var/run && \
    chgrp -R 0 ${ROOT_PATH} && \
    chmod -R g=u /etc/passwd ${ROOT_PATH} && \
    cp /etc/ssh/sshd_config ${ROOT_PATH}/etc/ssh/sshd_config && \
    sed -E 's:^#?AuthorizedKeysFile.*:AuthorizedKeysFile .ssh/authorized_keys:' -i ${ROOT_PATH}/etc/ssh/sshd_config && \
    sed -E "s:^#?HostKey /etc/ssh/ssh_host_(rsa|ecdsa|ed25519)_key:HostKey ${ROOT_PATH}/etc/ssh/ssh_host_\1_key:g" -i ${ROOT_PATH}/etc/ssh/sshd_config && \
    sed -E "s:^#?PidFile.*:PidFile ${ROOT_PATH}/var/run/sshd.pid:" && \
    sed -E 's/^#?Port.*/Port 10022/' -i ${ROOT_PATH}/etc/ssh/sshd_config && \
    sed -E 's/^#?PasswordAuthentication.*/PasswordAuthentication no/' -i ${ROOT_PATH}/etc/ssh/sshd_config && \
    sed -E 's/^#?UsePrivilegeSeparation.*/UsePrivilegeSeparation no/' -i ${ROOT_PATH}/etc/ssh/sshd_config && \
    sed -E 's/^#?UsePAM.*/UsePAM no/' -i ${ROOT_PATH}/etc/ssh/sshd_config && \
    sed -E 's/^#?StrictModes.*/StrictModes yes/' -i ${ROOT_PATH}/etc/ssh/sshd_config && \
    apt-get autoremove -y && \
    rm -rf /etc/ssh/ssh_host* /var/lib/apt/lists/*

COPY probe.sh ${ROOT_PATH}/bin/probe.sh

EXPOSE 10022 9999

WORKDIR ${ROOT_PATH}

ENTRYPOINT [ "./bin/probe.sh" ]

CMD [ "/usr/sbin/sshd", "-D", "-f", "./etc/ssh/sshd_config" ]