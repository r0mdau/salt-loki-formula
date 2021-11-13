loki:
  user.present:
    - fullname: Grafana Loki
    - shell: /usr/sbin/nologin
    - home: /opt/loki
    - uid: 4000
    - gid: 4000

loki_conf:
  file.managed:
    - user: loki
    - group: loki
    - mode: '0644'
    - name: /opt/loki/loki-config.yml
    - source: salt://loki/files/loki-config.yml

loki_binary:
  archive.extracted:
    - name: /usr/local/bin/loki
    - source: https://github.com/grafana/loki/releases/download/v2.4.1/loki-linux-amd64.zip
    - user: loki
    - group: loki
    - mode: '0755'

loki_systemd_unit:
  file.managed:
    - name: /etc/systemd/system/example.service
    - source: salt://loki/files/loki.service
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: loki_systemd_unit

loki_running:
  service.running:
    - name: loki
    - enable: True
    - watch:
      - module: loki_systemd_unit
