loki:
  user.present:
    - fullname: Grafana Loki
    - shell: /usr/sbin/nologin
    - home: /opt/loki

loki_conf:
  file.managed:
    - user: loki
    - group: loki
    - mode: '0644'
    - name: /opt/loki/loki-config.yml
    - source: salt://loki/files/loki-config.yml

loki_binary:
  archive.extracted:
    - name: /usr/local/bin
    - source: https://github.com/grafana/loki/releases/download/v2.4.1/loki-linux-amd64.zip
    - source_hash: 3235f2a77149a4f7867023a249438d8bf81287cc
    - user: loki
    - group: loki
    - enforce_toplevel: False

loki_systemd_unit:
  file.managed:
    - name: /etc/systemd/system/loki.service
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
