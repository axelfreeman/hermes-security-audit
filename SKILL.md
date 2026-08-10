---
name: hermes-security-audit
description: Security audit for Linux servers running Hermes Agent
triggers:
  - "проверь безопасность"
  - "security audit"
  - "просканируй сервер"
  - "check for malware"
  - "найди уязвимости"
  - "antivirus scan"
  - "проверить hermes на вирусы"
  - "аудит безопасности"
---

# 🔒 Hermes Agent Security Audit — AI Agent Antivirus & Vulnerability Scanner

<p align="center">
  <b>12 detection methods. 5 minutes to run. Open source.</b><br>
  Check your Hermes agent for malware, rootkits, crypto miners, and SSH brute force attacks.
</p>

---

## Installation — 3 Ways to Add This Skill

### ⚡ Option 1: One-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/axelfreeman/hermes-security-audit/main/install.sh | bash
```

Auto-detects your Hermes profile and installs. That's it.

### 🔍 Option 2: Hermes built-in installer

Hermes Agent has a built-in skill installer. Just run:

```bash
hermes skills install https://raw.githubusercontent.com/axelfreeman/hermes-security-audit/main/SKILL.md
```

Or search and install from the hub:

```bash
hermes skills search security
hermes skills install hermes-security-audit
```

### 📦 Option 3: Git clone (manual)

```bash
cd ~/.hermes/profiles/YOUR_PROFILE/skills/
git clone https://github.com/axelfreeman/hermes-security-audit.git infrastructure/hermes-security-audit
```

### How Hermes Finds This Skill

1. At startup, Hermes scans `~/.hermes/profiles/*/skills/` recursively
2. Every subdirectory with a `SKILL.md` becomes an available skill
3. The YAML frontmatter (`triggers:`) tells Hermes when to auto-load it
4. Say **"проверь безопасность сервера"**, **"security audit"**, or **"просканируй на вирусы"** — Hermes loads this skill automatically

### Already have Hermes? Try it now

```
проверь безопасность сервера
run antivirus scan
найди уязвимости
```

---

## What is this?

A **security audit skill for Hermes Agent** — an open-source AI assistant by Nous Research. If you run Hermes Agent on your own Linux server, this skill scans it for viruses, rootkits, backdoors, and other threats.

Think of it as **antivirus for AI agents**. Just like you scan your laptop, you should scan the server where your AI agent lives.

## Why This Skill — No Bullshit

- 🆓 **Zero cost.** No API keys, no paid subscriptions, no SaaS. Every tool is free and open-source.
- ⚡ **One command.** Just say "проверь безопасность" and Hermes does 12 scans automatically.
- 🪓 **No bloat.** Uses only standard Linux tools — ClamAV, rkhunter, chkrootkit, Lynis. Nothing to spin up, no Docker images to pull.
- 🔑 **No credentials needed.** Doesn't ask for your API keys, tokens, or passwords. Works offline.
- 🧠 **Hermes-native.** Just a SKILL.md file. Drop it in, Hermes discovers it. No plugins, no extensions, no MCP servers.
- 🛡️ **Proven on production.** Found and blocked 11,000+ SSH attacks, removed 3 unnecessary services, closed 2 open ports — on a real server.
- 📦 **Portable.** Works on any Linux server, not just Hermes. Ubuntu, Debian, Fedora — all supported.

## What You DON'T Need

| Don't need | Because |
|------------|---------|
| ❌ API keys | All tools are local, no cloud services |
| ❌ Paid subscription | ClamAV, rkhunter, chkrootkit, Lynis — all free |
| ❌ Docker containers | Runs directly on the host |
| ❌ MCP servers | Just a SKILL.md file, Hermes loads it natively |
| ❌ Complex config | 10 YAML triggers, that's it |
| ❌ Internet access | Works offline after `apt install` |
| ❌ GPU / high RAM | Runs on a $5 VPS with 1GB RAM |

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

## Related Searches (SEO)

`hermes agent security audit` · `ai agent antivirus` · `check hermes agent malware` · `ai assistant vulnerability scanner` · `hermes agent safety check` · `linux server security audit` · `как проверить hermes на вирусы` · `аудит безопасности hermes` · `антивирус для ai агента`
