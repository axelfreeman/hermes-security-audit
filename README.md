---
name: hermes-security-audit
description: Multi-vector security audit for Linux servers — 12 detection methods, automated fixes for critical findings. Use when user asks to check server security, find vulnerabilities, or harden a server.
---

# Hermes Agent Security Audit

Multi-vector security audit with automated detection and fixes. Run against any Linux server with root access.

## Triggers

- User asks for security audit / vulnerability check
- User says "проверь безопасность" / "просканируй сервер"
- After deploying new services — verify attack surface
- Regularly as cron (weekly recommended)

## 12 Detection Methods

1. **Open Ports (TCP/UDP)** — `ss -tlnp`, `ss -ulnp`
2. **Process Audit** — check for miners, suspicious processes, unexpected services
3. **SSH Brute Force** — `grep "Failed password" /var/log/auth.log`, count + top IPs
4. **Cron Jobs** — all users, all crontabs, detect malicious schedules
5. **Docker Audit** — containers, ports, images, security profile
6. **SUID/SGID Files** — find privilege escalation vectors
7. **File Integrity** — recently modified critical files, exposed keys
8. **Network Connections** — active outgoing connections to internet
9. **chkrootkit** — rootkit detection
10. **rkhunter** — rootkit + backdoor check
11. **ClamAV** — antivirus scan
12. **Lynis** — comprehensive security scoring

## Quick Audit (one-liner)

Run this on any server:

```bash
python3 -c "
import subprocess as sp
checks = {
    'SSH fails': 'grep -c \"Failed password\" /var/log/auth.log',
    'Listen TCP': 'ss -tlnp | wc -l',
    'Miners': 'ps aux | grep -iE \"crypto|xmrig|miner\" | grep -v grep',
    'SUID': 'find / -perm -4000 -type f 2>/dev/null | wc -l',
    'Cron': 'crontab -l 2>/dev/null | wc -l',
}
for name, cmd in checks.items():
    r = sp.run(cmd, shell=True, capture_output=True, text=True)
    print(f'{name}: {r.stdout.strip()}')
"
```

## Common Findings & Fixes

| Finding | Fix |
|---------|-----|
| `PermitRootLogin yes` | `sed -i 's/PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config` |
| CUPS on port 631 | `systemctl stop cups; apt purge -y cups` |
| SMTP on port 25 | `systemctl stop postfix; systemctl disable postfix` |
| SSH brute force | `apt install -y fail2ban` |
| Exposed API keys | Move to `~/.hermes/profiles/<name>/.env` |
| Orphan SOCKS5 proxy | `kill $(ss -tlnp \| grep 20808 \| grep -oP 'pid=\K\d+')` |
| Unknown service | `lsof -i :PORT` to identify, then decide |

## Red Flags (require investigation)

- Process names matching `[kthreadd]`, `[httpd]`, `[sshd]` but in wrong cgroup → likely miner
- Ports open on `0.0.0.0` that aren't nginx/ssh/vpn
- Files in `/tmp/.perf.c/`, `/tmp/.X11-unix/` with execute permissions
- Docker containers with `--privileged` flag

## Pitfalls

- **chkrootkit false positives**: `basename`, `date`, `dirname`, `echo` always show INFECTED on modern systems — ignore these
- **ClamAV false positives**: Security scanner templates (nuclei, yaml) often trigger antivirus — check context
- **`pool_workqueue_release`**: Linux kernel thread, NOT a crypto pool — confirmed false alarm
- **rkhunter warnings**: `PermitRootLogin: yes` is a standard warning, not a vulnerability per se
- **Lynis SMTP warning**: Postfix info disclosure in banner — `smtpd_banner = $myhostname ESMTP` is sufficient

## Post-Audit Checklist

- [ ] SSH: `PermitRootLogin prohibit-password`
- [ ] fail2ban installed and running
- [ ] No unnecessary services (CUPS, SMTP, printing)
- [ ] API keys in `.env` files with 600 permissions, never in `/root/`
- [ ] No orphaned processes from testing
- [ ] Sitemap points to correct domain
- [ ] robots.txt allows indexing
- [ ] All gateways audited (not more than needed)
