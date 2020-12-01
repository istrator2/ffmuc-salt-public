duplicity-packages:
  pkg.installed:
    - pkgs:
      - duplicity
      - gnupg 
      - gnupg-agent
      - python3-pip
    - require:
      - pkgrepo: duplicity_repo

duplicity_repo:
  pkgrepo.managed:
    - ppa: duplicity-team/duplicity-release-git
    - keyid: 8F571BB27A86F4A2
    - keyserver: pgp.mit.edu

backup-script:
  file.managed:
    - name: /usr/local/sbin/backup.sh
    - source: salt://duplicity/files/backup.sh.jinja2
    - template: jinja

b2sdk:
  pip.installed:
    - require:
      - pkg: duplicity-packages

/etc/systemd/system/ffmuc-backup.service:
  file.managed:
    - source: salt://duplicity/files/ffmuc-backup.service

/etc/systemd/system/ffmuc-backup.timer:
  file.managed:
    - source: salt://duplicity/files/ffmuc-backup.timer

systemd-reload-ffmuc-backup:
  cmd.run:
    - name: systemctl --system daemon-reload
    - onchanges:
      - file: /etc/systemd/system/ffmuc-backup.service
      - file: /etc/systemd/system/ffmuc-backup.timer