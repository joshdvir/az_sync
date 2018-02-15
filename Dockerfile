FROM microsoft/azure-cli

ENV INTERVAL_IN_HOURS=12

RUN apk update && apk add \
      bash \
      curl

ADD https://bin.equinox.io/c/ekMN3bCZFUn/forego-stable-linux-amd64.tgz /forego.tgz
RUN cd /usr/local/bin && tar xfz /forego.tgz && chmod +x /usr/local/bin/forego && rm /forego.tgz

WORKDIR /opt

RUN echo $'#!/bin/bash\n\
\n\
set -e \n\
while true; do\n\
  az storage blob upload-batch --source $DATA_FOLDER --destination $DESTINATION \n\
  sleep $(( 60*60*INTERVAL_IN_HOURS ))\n\
done' > s3.sh && chmod +x s3.sh

RUN echo 's3: /opt/s3.sh' >> Procfile

CMD [ "forego", "start" ]