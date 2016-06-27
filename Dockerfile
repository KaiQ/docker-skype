FROM fedora:latest

MAINTAINER Kai Trott <kaitrott@gmaill.com>

RUN dnf update -y
RUN dnf install -y wget
RUN wget https://download.skype.com/linux/skype-4.3.0.37-fedora.i586.rpm -O /tmp/skype.rpm
RUN dnf install -y /tmp/skype.rpm
RUN echo $(dbus-uuidgen) > /etc/machine-id

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
