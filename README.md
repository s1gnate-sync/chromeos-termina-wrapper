# chromeos-termina-wrapper
Wrapper around termina and lxd so you can call them from crosh shell for various automation tasks.

# Prerequisites
A device running Chromium OS that has been switched to developer mode is needed.

# Usage
Run "'# bash install.sh" to install termina wrapper into local bin folder.

## Execute shell command
```
$ termina ls / 
bin  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  sys  tmp  usr  var
```

## Run multiple shell commands
```
$ (
    cat << EOF
    uname -a
    uptime
EOF
) | termina
Linux localhost 5.15.108-18910-gab0e1cb584e1 #1 SMP PREEMPT Wed Jun 21 23:22:16 PDT 2023 aarch64 GNU/Linux
 07:55:57 up 12 min,  0 users,  load average: 0.02, 0.13, 0.15
```

## Execute lxc command
```
$ lxc ls
+---------------------------+---------+-----------------------+------+-----------+-----------+
|           NAME            |  STATE  |         IPV4          | IPV6 |   TYPE    | SNAPSHOTS |
+---------------------------+---------+-----------------------+------+-----------+-----------+
| build-distrobuilder-cache | STOPPED |                       |      | CONTAINER | 0         |
+---------------------------+---------+-----------------------+------+-----------+-----------+
| penguin                   | RUNNING | 100.115.92.194 (eth0) |      | CONTAINER | 0         |
+---------------------------+---------+-----------------------+------+-----------+-----------+
```

## Push files to container
```
$ cat "id_rsa.pub" | lxc file push - "penguin/root/.ssh/id_rsa.pub"
```

## Execute multiple commands inside lxd container
```
$ (
    cat << EOF
    apt-get update --yes
    apt-get install --yes --no-install-recommends \
        btrfs-progs \
        build-essential \
        ca-certificates \
        debootstrap
EOF
) | lxc exec penguin -- sh
Hit:3 https://deb.debian.org/debian-security bookworm-security InRelease
Ign:4 https://storage.googleapis.com/cros-packages/114 bookworm InRelease
...
```

## Copy artifacts from container
```
$ lxc exec penguin -- tar -cf - -C /root/build/ . | tar -xf - -C build
```

## Backup container
```
$ (
    cat << EOF
    lxc export penguin /tmp/penguin.tar.gz 
    cat /tmp/penguin.tar.gz 
EOF
) | termina > backup.tar.gz
```

# Use-cases
- As simple way to create and destroy temporary containers
- To provision container with some local data
- Backups (import/export)