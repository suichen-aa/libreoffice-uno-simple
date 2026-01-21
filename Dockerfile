FROM alpine:3.19

ARG TZ=Asia/Shanghai
ARG LOCALE=zh_CN.UTF-8

RUN set -x \
    && apk add --no-cache \
       libreoffice-writer \
       libreoffice-calc \
       libreoffice-impress \
       libreoffice-common \
       font-noto-cjk \
       font-noto-cjk-extra \
       ttf-dejavu \
       fontconfig \
       tzdata \
       musl-locales \
       dbus \
    && rm -rf /var/cache/apk/* \
    && fc-cache -fv \
    && mkfontscale /usr/share/fonts \
    && mkfontdir /usr/share/fonts \
    && echo "export LC_ALL=${LOCALE}" >> /etc/profile.d/locale.sh \
    && echo "export LANG=${LOCALE}" >> /etc/profile.d/locale.sh \
    && echo "export LANGUAGE=${LOCALE}" >> /etc/profile.d/locale.sh \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && mkdir -p /tmp/libreoffice \
    && chmod 777 /tmp/libreoffice

COPY fonts/ /usr/share/fonts/winfonts/

RUN chmod 644 /usr/share/fonts/winfonts/* \
    && fc-cache -fv \
    && mkfontscale /usr/share/fonts/winfonts \
    && mkfontdir /usr/share/fonts/winfonts

ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    LANGUAGE=zh_CN.UTF-8 \
    TZ=Asia/Shanghai \
    TMPDIR=/tmp/libreoffice \
    DISPLAY=:99 \
    HOME=/tmp

EXPOSE 8100

ENTRYPOINT []
CMD ["/usr/bin/libreoffice", \
     "--headless", \
     "--accept=socket,host=0.0.0.0,port=8100,tcpNoDelay=1;urp;LibreOffice.ComponentContext", \
     "--norestore", \
     "--nolockcheck", \
     "--nologo", \
     "--nodefault", \
     "--nofirststartwizard", \
     "--minimized"]