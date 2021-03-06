FROM alpine:3.9
LABEL maintainer="Pedro Lobo <https://github.com/pslobo>"
LABEL Name="Dockerized Certbot"
LABEL Version="1.2"

WORKDIR /opt/certbot
ENV PATH "/root/.cargo/bin:/opt/certbot/venv/bin:$PATH"

RUN export BUILD_DEPS="git \
                curl \
                build-base \
                libffi-dev \
                linux-headers \
                python3-dev" \
    && apk -U upgrade \
    && apk add dialog \
               python3 \
               rust \
               openssl-dev \
	       augeas-libs \
               ${BUILD_DEPS} \
    && curl https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-musl/rustup-init --output /tmp/rustup-init \
    && chmod +x /tmp/rustup-init \
    && /tmp/rustup-init -y \
    &&  echo "**** install pip ****" \
    # && ls -l /usr/lib/python*/ensurepip \
    && python3 -m ensurepip \
    && pip3 --version \
    && python3 -m pip install -U pip \
    && pip3 --no-cache-dir install virtualenv \
    && git clone https://github.com/letsencrypt/letsencrypt /opt/certbot/src \
    && virtualenv -p python3 /opt/certbot/venv \
    && /opt/certbot/venv/bin/pip3 install \
        -e /opt/certbot/src/acme \
        -e /opt/certbot/src/certbot \
        -e /opt/certbot/src/certbot-dns-route53 \
    && apk del ${BUILD_DEPS} \
    && rm -rf /var/cache/apk/* \
    && rustup self uninstall -y

EXPOSE 80 443
VOLUME /etc/letsencrypt 

COPY ./docker-tools/run.sh /opt/certbot/run.sh
RUN chmod +x /opt/certbot/run.sh
COPY ./docker-tools/certbotloop.py /opt/certbot/certbotloop.py
RUN chmod +x /opt/certbot/certbotloop.py

ENTRYPOINT ["/opt/certbot/run.sh"]
