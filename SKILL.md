---
name: hermes-security-audit
description: Free security audit for Linux servers — no API keys, no paid tools. Scans for viruses (ClamAV), rootkits (rkhunter + chkrootkit), SSH brute force, crypto miners, exposed credentials, and open ports. 12 detection methods, proven on production (11,000+ attacks found and blocked). Use when the user asks to audit or harden a Linux server, check for malware/rootkits/crypto miners, scan open ports, or detect SSH brute force — "security audit", "check for malware".
version: 1.0.0
author: Axel Freeman
license: MIT
metadata:
  hermes:
    tags: [security, audit, antivirus, rootkit, hardening, linux]
    cost: free
    requires_api_key: false
    requires_docker: false
    runs_offline: true
---

# 🔒 Hermes Agent Security Audit — AI Agent Antivirus & Vulnerability Scanner

**Free. Open-source.** No API keys, no paid tools, no Docker. 12 battle-tested security checks for Linux servers running AI agents.

## When to Use

- The user asks to audit or harden a Linux server.
- Checking for malware, rootkits, crypto miners, or SSH brute force.
- After installing new tools or Docker containers.
- When CPU or memory usage looks unusual.
- Before exposing the agent to external platforms (Telegram, Discord).

## The 12 checks

1. **Open ports** — find hidden services (CUPS 631, SMTP 25, Zabbix 10050).
2. **Process audit** — spot crypto miners (xmrig, stratum) and orphaned proxies.
3. **SSH brute force** — count failed auth attempts, identify attacker IPs.
4. **SUID/SGID files** — privilege-escalation vectors.
5. **Cron jobs** — hidden miners and persistence across all users.
6. **Docker audit** — privileged containers, host network, unexpected images.
7. **chkrootkit** — signature-based rootkit scan.
8. **rkhunter** — behavioral rootkit + backdoor scan.
9. **ClamAV** — full antivirus over /tmp, /opt, /root.
10. **Lynis** — hardening score (0–100).
11. **Exposed credentials** — API keys, tokens, private keys in plain sight.
12. **Network connections** — who's calling home.

The exact commands for each method live in `AGENTS.md`.

## Procedure

1. Run the 12 checks in order.
2. Classify each finding by severity (critical / high / medium / low).
3. Apply safe fixes where automated (fail2ban, disable services, relocate keys).
4. Report results with severity, flagging known false positives.

## Pitfalls

- chkrootkit false-positives on modern kernels (`basename`, `date`, `dirname`) — expected, don't alarm.
- rkhunter flags snap users and hidden config files — benign.
- Never run destructive commands without user confirmation.

## Verification

- Each of the 12 checks produced a result.
- Findings are classified by severity and fixed or flagged.
- The final report lists what changed (ports closed, services disabled, keys moved).
