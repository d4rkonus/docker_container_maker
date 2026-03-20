FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    nginx \
    openssh-server \
    mkdir /var/run/sshd

RUN useradd -m revali && echo "revali:monkey" | chpasswd

# Configurar SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

COPY index.html /var/www/html/index.html
COPY .backup.html /var/www/html/.backup.html

EXPOSE 80 22 

CMD service ssh start && nginx -g "daemon off;"