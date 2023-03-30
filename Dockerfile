ARG BASE_IMAGE

FROM $BASE_IMAGE

ENV ROOT_PATH /opt/gatling

COPY docker-entrypoint ${ROOT_PATH}/bin/

RUN chmod 755 ${ROOT_PATH}/bin/docker-entrypoint && \
    chmod -R ug=rwx /opt/gatling

WORKDIR ${ROOT_PATH}

EXPOSE 9999

ENTRYPOINT ["./bin/docker-entrypoint"]
CMD ["/bin/sh", "-c", "cat"]
