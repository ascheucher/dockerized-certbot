FROM alpine:3.7
LABEL maintainer="Pedro Lobo <https://github.com/pslobo>"
LABEL Name="Dockerized Certbot"
LABEL Version="1.2"

WORKDIR /opt/certbot
ENV PATH /opt/certbot/venv/bin:$PATH

RUN export BUILD_DEPS="git \
                build-base \
                libffi-dev \
                linux-headers \
                python3-dev" \
    && apk -U upgrade \
    && apk add dialog \
               python3 \
               openssl-dev \
		       augeas-libs \
               ${BUILD_DEPS} \
    &&  echo "**** install pip ****" \
    # && ls -l /usr/lib/python*/ensurepip \
    && python3 -m ensurepip \
    && pip3 --version \
    && python3 -m pip install -U pip \
    && pip3 --no-cache-dir install virtualenv \
    && git clone https://github.com/letsencrypt/letsencrypt /opt/certbot/src \
    && virtualenv -p python3 /opt/certbot/venv 
RUN echo ls -l /opt/certbot && ls -l \
    && echo which python3 && which python3 \
    && echo ls -l src && ls -l src \
    && echo ls -l /opt/certbot/src/acme && ls -l /opt/certbot/src/acme \
    && echo ls -l /opt/certbot/src/certbot && ls -l /opt/certbot/src/certbot \
    && echo ls -l /opt/certbot/src/certbot-dns-route53 && ls -l /opt/certbot/src/certbot-dns-route53 \
    && /opt/certbot/venv/bin/pip3 install \
        -e /opt/certbot/src/acme \
        -e /opt/certbot/src/certbot \
        -e /opt/certbot/src/certbot-dns-route53
RUN echo find / -name certbot && find / -name certbot
RUN export BUILD_DEPS="git build-base libffi-dev linux-headers python-dev" apk del ${BUILD_DEPS}
RUN rm -rf /var/cache/apk/*

EXPOSE 80 443
VOLUME /etc/letsencrypt 

COPY ./docker-tools/run.sh /opt/certbot/run.sh
RUN chmod +x /opt/certbot/run.sh
COPY ./docker-tools/certbotloop.py /opt/certbot/certbotloop.py
RUN chmod +x /opt/certbot/certbotloop.py

ENTRYPOINT ["/opt/certbot/run.sh"]
