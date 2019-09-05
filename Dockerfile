FROM openjdk:8u222-jdk-slim

ENV ROOT_PATH /opt/frontline/probe

COPY probe bootstrap ${ROOT_PATH}/bin/

RUN chmod 755 ${ROOT_PATH}/bin/probe ${ROOT_PATH}/bin/bootstrap

WORKDIR ${ROOT_PATH}

EXPOSE 9999

ENTRYPOINT ["./bin/probe"]
CMD ["/bin/sh", "-c", "cat"]
