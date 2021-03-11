# Arch Linux

SSH Remote Installation

---

Enable ssh service from the live iso installation media

```bash
# passwd
# ip addr
# systemctl status sshd
# systemctl start sshd
```

---

SSH to remote host

```bash
ssh root@192.168.0.42
```

## Install

```bash
cd ~/dev/dotfiles/arch-linux
chmod +x ./run.sh
./run.sh
```
