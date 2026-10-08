FROM alpine:latest
RUN apk add --no-cache wget unzip

# Téléchargement et installation de l'application de tunnel
RUN wget -O /v2ray.zip https://github.com && \
    unzip /v2ray.zip -d /v2ray && \
    rm /v2ray.zip

# Écriture de la configuration double : VLESS et Trojan sur le port 7860
RUN mkdir -p /etc/v2ray && echo '{\
  "inbounds": [\
    {\
      "port": 7860,\
      "protocol": "vless",\
      "settings": {\
        "clients": [{"id": "MonSuperPassword123"}],\
        "decryption": "none"\
      },\
      "streamSettings": {\
        "network": "ws",\
        "wsSettings": {"path": "/vless-prive"}\
      }\
    },\
    {\
      "port": 7860,\
      "protocol": "trojan",\
      "settings": {\
        "clients": [{"password": "MonSuperPassword123"}]\
      },\
      "streamSettings": {\
        "network": "ws",\
        "wsSettings": {"path": "/trojan-prive"}\
      }\
    }\
  ],\
  "outbounds": [{"protocol": "freedom"}]\
}' > /etc/v2ray/config.json

EXPOSE 7860
CMD ["/v2ray/v2ray", "run", "-config", "/etc/v2ray/config.json"]
