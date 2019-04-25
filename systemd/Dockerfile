FROM centos/systemd

COPY ./custom-init.sh /tmp/custom-init.sh
COPY ./custom-init.service /etc/systemd/system/custom-init.service

RUN systemctl enable custom-init.service

CMD ["/usr/sbin/init"]