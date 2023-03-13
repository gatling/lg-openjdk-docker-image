ARG base_image

FROM $base_image

RUN apt-get update && \
    apt-get install -y \
      curl \
      jq && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV ROOT_PATH /opt/gatling

COPY docker-entrypoint bootstrap ${ROOT_PATH}/bin/

RUN chmod 755 ${ROOT_PATH}/bin/docker-entrypoint ${ROOT_PATH}/bin/bootstrap && \
    chmod -R ug=rwx /etc/passwd /opt/gatling

WORKDIR ${ROOT_PATH}

EXPOSE 9999

ENTRYPOINT ["./bin/docker-entrypoint"]
CMD ["/bin/sh", "-c", "cat"]
