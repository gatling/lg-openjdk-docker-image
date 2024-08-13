ARG BASE_IMAGE

FROM $BASE_IMAGE

ENV ROOT_PATH /opt/gatling
ENV HOME=${ROOT_PATH}

COPY --chmod=775 --chown=1001:0 docker-entrypoint /opt/gatling/bin/

RUN touch /etc/passwd && \
    chmod -R ug=rwx /etc/passwd /opt/gatling

USER 1001
WORKDIR ${ROOT_PATH}
ENTRYPOINT ["./bin/docker-entrypoint"]
CMD ["/bin/sh", "-c", "cat"]
