FROM alpine:latest

COPY calldataset.sh /calldataset.sh
RUN chmod +x /calldataset.sh

RUN apk update \
    && apk add --no-cache bash

ENTRYPOINT ["/calldataset.sh"]