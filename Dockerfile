# syntax=docker/dockerfile:experimental

FROM alpine:3.11 as bld

ARG ZOPFLI_VER

RUN --mount=type=cache,target=/var/cache/apk \ 
    ln -vs /var/cache/apk /etc/apk/cache \
    && apk add --virtual .build-deps build-base

WORKDIR = /home
COPY entrypoint.sh /usr/local/bin/
ADD https://github.com/google/zopfli/archive/zopfli-${ZOPFLI_VER}.tar.gz ./zopfli.tar.gz
RUN echo    ' - install zopfli' \
    && tar -C /tmp -xf ./zopfli.tar.gz \
    && mv /tmp/*${ZOPFLI_VER} /tmp/zopfli \
    && cd /tmp/zopfli \
    && make zopfli \
    # && ls -al . \
    # && echo '---------------------------' \
    # && ls -al /usr/local/bin \
    # && false \
    && mv zopfli /usr/local/bin/ \
    && echo ' -  remove apk install deps' \
    && apk del .build-deps \
    && rm -r /tmp/zopfli \
    && echo '---------------------------'

FROM alpine:3.11 as zopfli

COPY --from=bld /usr/local /usr/local
WORKDIR /usr/local/bin
ENV LANG C.UTF-8
ENTRYPOINT ["entrypoint.sh"]





#     && cd /tmp/zopfli-${ZOPFLI_VER} \
#     && ls . \
#     && echo ' -  remove apk install deps' \
#     && apk del .build-deps \
#     && echo '---------------------------'  

