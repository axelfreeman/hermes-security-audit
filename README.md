# 🔒 Hermes Agent Security Audit — AI Agent Antivirus & Vulnerability Scanner

[![skills.sh](https://skills.sh/b/axelfreeman/hermes-security-audit)](https://skills.sh/axelfreeman/hermes-security-audit)

<p align="center">
  <a href="https://github.com/axelfreeman/hermes-security-audit/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT"></a>
  <a href="https://github.com/axelfreeman/hermes-security-audit/stargazers"><img src="https://img.shields.io/github/stars/axelfreeman/hermes-security-audit?style=flat-square" alt="GitHub stars"></a>
  <a href="https://github.com/axelfreeman"><img src="https://img.shields.io/badge/author-Axel%20Freeman-0A0A0A?style=flat-square" alt="Author"></a>
</p>

<p align="center"><i>⭐ Star this repo to help more people audit their AI agents for malware.</i></p>

<p align="center">
  <b>12 detection methods. 5 minutes to run. Open source.</b><br>
  Check your Hermes agent for malware, rootkits, crypto miners, and SSH brute force attacks.
</p>

---

## What is this?

A **security audit skill for Hermes Agent** — an open-source AI assistant by Nous Research. If you run Hermes Agent on your own Linux server, this skill scans it for viruses, rootkits, backdoors, and other threats.

Think of it as **antivirus for AI agents**. Just like you scan your laptop, you should scan the server where your AI agent lives.

## Why you need an AI agent security audit

Hermes Agent runs on Linux servers with root access, Docker containers, API keys, and open network ports. That's a lot of attack surface. This **Hermes agent vulnerability scanner** checks:

| Threat | Detection Method |
|--------|-----------------|
| 🦠 **Viruses & malware** | ClamAV — industry-standard antivirus |
| 👻 **Rootkits & backdoors** | rkhunter + chkrootkit — dual rootkit detection |
| ⛏️ **Crypto miners** | Process audit — signature + behavioral analysis |
| 🔑 **Exposed credentials** | File scan — API keys, tokens, private keys in plain sight |
| 🚪 **Open doors** | Port audit — unnecessary services (CUPS, SMTP, printing) |
| 🤖 **SSH brute force** | Log analysis — 11,000+ failed attempts found and blocked |
| 🐳 **Docker escapes** | Container audit — privileged mode, exposed ports |
| 📅 **Hidden cron jobs** | Cron audit — all users, all schedules |
| 📁 **SUID/SGID exploits** | Privilege escalation vector detection |
| 🌐 **Outbound connections** | Network connection audit — who's calling home |

## Quick Start

```bash
# 1. Install Hermes Agent (if not already)
# https://github.com/nous-research/hermes-agent

# 2. Load the security skill
hermes skill load hermes-security-audit

# 3. Run the audit
# Say to your Hermes agent: "проверь безопасность сервера"
```

Or just copy the [SKILL.md](SKILL.md) into `~/.hermes/profiles/your_profile/skills/`.

## 12 Security Checks — Full Breakdown

### 1. Open Ports (TCP/UDP)
Detects hidden services listening on unexpected ports. **Finding:** CUPS print service on port 631, SMTP on port 25, Zabbix agent on 10050 — all unnecessary, all removed.

### 2. Process Audit
Scans for crypto miners (`xmrig`, `stratum`), suspicious process names mimicking legitimate ones, and orphaned services. **Finding:** orphaned Xray SOCKS5 proxy from previous testing — killed.

### 3. SSH Brute Force Detection
Counts failed authentication attempts and identifies attacker IPs. **Finding:** **11,099 failed SSH attempts** across three servers. Top attacker IPs blocked, fail2ban installed.

### 4. SUID/SGID Files
Finds binaries with elevated privileges — potential privilege escalation vectors. **Finding:** 0 dangerous SUID files found.

### 5. Cron Job Audit
Lists crontabs for all system users. **Finding:** legitimate outreach scripts and certbot renewals — no hidden miners.

### 6. Docker Container Audit
Checks all containers for privileged mode, host network access, and unexpected images. **Finding:** only known containers running (amnezia-awg2, open-seo).

### 7. chkrootkit
Signature-based rootkit scanner. **Finding:** false positives for `basename`, `date`, `dirname` — expected on modern kernels.

### 8. rkhunter
Behavioral rootkit and backdoor detection. **Finding:** standard warnings for snap users, hidden config files — all benign.

### 9. ClamAV
Full antivirus scan of `/tmp`, `/opt`, and `/root`. **Finding:** 0 infected files.

### 10. Lynis Security Score
Comprehensive hardening audit with numerical score. **Finding:** initial score **65/100** — improved by disabling unnecessary services.

### 11. Exposed Credentials
Scans home directories for API keys, tokens, private keys stored in plain text. **Finding:** Amnezia VPN private keys moved to protected storage.

### 12. Network Connections
Checks active outbound connections for suspicious destinations. **Finding:** only legitimate Hermes gateway and Chrome browser connections.

## Real Results from Production Server

```
Server: 195.133.93.243 (Hetzner, Ubuntu 26.04)
Profile: Hermes Agent marketing profile + 2 additional gateways

Before audit:
  - PermitRootLogin: yes (password auth allowed)
  - Open ports: 22, 25, 443, 631, 10050, 18960, 20808
  - SSH brute force: 3,194 failed attempts
  - VPN private keys: exposed in /root/
  - Lynis hardening index: 65/100

After audit + fixes:
  - PermitRootLogin: prohibit-password (key-only auth)
  - Open ports: 22, 443, 18960 (memmy-agent)
  - SSH brute force: fail2ban active, 8 attacker IPs blocked
  - VPN keys: moved to ~/.hermes/profiles/ (600 permissions)
  - Lynis hardening index: 72/100 (+7 points)
  - CUPS, SMTP, Xray SOCKS5: all removed
```

## When to Run This Audit

- ✅ After installing Hermes Agent on a new server
- ✅ Weekly as a cron job (`0 0 * * 0`)
- ✅ After installing new tools or Docker containers
- ✅ When you notice unusual CPU/memory usage
- ✅ Before exposing your agent to external platforms (Telegram, Discord)

## Who Is This For?

- **Hermes Agent users** running self-hosted instances
- **AI agent developers** who want to secure their infrastructure
- **Linux server admins** — works on any Linux server, not just Hermes
- **Security-conscious teams** building on open-source AI tools

## Related Searches (SEO)

People find this skill by searching:

`hermes agent security audit` · `ai agent antivirus` · `check hermes agent malware` · `ai assistant vulnerability scanner` · `hermes agent safety check` · `linux server security audit` · `how to check hermes agent for malware` · `is hermes agent safe to use` · `hermes agent vulnerability scanner` · `ai agent malware detection` · `hermes agent rootkit scan` · `open source ai agent security` · `how to secure hermes agent server` · `detect crypto miners on ai server`

На русском: `проверка hermes agent на вирусы` · `аудит безопасности hermes агента` · `антивирус для ai агента` · `проверка безопасности hermes` · `защита hermes агента от взлома` · `сканер уязвимостей hermes agent` · `безопасность ai ассистента` · `как проверить hermes на вирусы`

## License

MIT — use, modify, share freely. Part of [Axel Freeman's](https://github.com/axelfreeman) open-source marketing and security toolkit.
---

*Last updated: August 2026.*
