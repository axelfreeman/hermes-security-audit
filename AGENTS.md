# Hermes Security Audit — AGENTS.md

## What This Project Is

A **free, open-source security audit skill** for Hermes Agent. Runs 12 detection methods on Linux servers: antivirus (ClamAV), rootkit detection (rkhunter + chkrootkit), SSH brute force analysis, crypto miner detection, exposed credential scanning, port audits, Docker container checks, cron job inspection, SUID/SGID privilege escalation vectors, network connection monitoring, and Lynis hardening scoring.

**No API keys. No paid tools. No Docker required.** Runs entirely on standard Linux packages.

The skill is a single `SKILL.md` file that Hermes Agent loads as a skill. When triggered by keywords like "security audit", the agent follows the methodology encoded in the skill to run the 12 checks, interpret results, and apply fixes.

## Architecture

```
hermes-security-audit/
├── SKILL.md          # Core skill file — loaded by Hermes Agent
├── README.md         # English docs (SEO-optimized)
├── README_RU.md      # Russian docs
├── SEMANTICS.md      # Keyword research + content plan
├── install.sh        # One-liner installer via curl
└── AGENTS.md         # This file — agent instructions
```

### How the Skill Works

1. **SKILL.md** is a Hermes Agent skill with YAML frontmatter containing:
   - 20 trigger phrases (EN + RU)
   - Metadata: `cost: free`, `requires_api_key: false`, `runs_offline: true`
   - Install method URL

2. When the agent matches a trigger phrase, the skill content enters the agent's system prompt. The agent then:
   - Reads the methodology from the skill's attached `references/` (audit-methodology.md)
   - Runs each of the 12 detection methods via terminal commands
   - Reports findings with severity levels
   - Applies automated fixes where safe (fail2ban, service disabling, key relocation)

3. The skill ships with three reference documents (loaded as linked files):
   - `audit-methodology.md` — Step-by-step commands for all 12 methods
   - `production-audit-2026-08-10.md` — Real results from production server
   - `gateway-restart-workarounds.md` — Workarounds for Hermes gateway command blocking

## The 12 Detection Methods

Commands are runnable on any Linux server. All tools install via `apt`.

### 1. Port Audit (TCP/UDP)
```bash
ss -tlnp | awk '{print $4, $NF}' | sort -u
ss -ulnp | head -10
```
**Looks for:** CUPS (631), SMTP (25), Zabbix (10050), unknown services on high ports.

### 2. Process Audit
```bash
ps aux --sort=-%cpu | head -20
ps aux | grep -iE "crypto|xmrig|miner|stratum|pool|donate"
```
**Looks for:** Crypto miners, suspicious process names, orphaned proxies.

### 3. SSH Brute Force Detection
```bash
grep -c "Failed password" /var/log/auth.log
grep "Failed password" /var/log/auth.log | grep -oP "from \K[\d.]+" | sort | uniq -c | sort -rn | head -10
```
**Fix:** `apt install -y fail2ban` + block top attacker IPs via iptables.

### 4. SUID/SGID Files
```bash
find / -perm -4000 -type f 2>/dev/null | grep -v '/snap/'
```
**Looks for:** Privilege escalation vectors. Most results (sudo, passwd) are legitimate.

### 5. Cron Job Audit
```bash
for user in $(cut -f1 -d: /etc/passwd); do crontab -u $user -l 2>/dev/null; done
cat /etc/crontab
ls /etc/cron.d/
```
**Looks for:** Hidden miners, persistence mechanisms.

### 6. Docker Container Audit
```bash
docker ps -a --format '{{.Names}} {{.Status}} {{.Ports}}'
docker info | grep -E "Security|seccomp|apparmor"
```
**Flags:** `--privileged` containers, host network mode, unexpected images.

### 7. chkrootkit
```bash
apt install -y chkrootkit
chkrootkit | grep -v "not found\|not infected\|nothing detected"
```
**Known false positives:** `basename`, `date`, `dirname`, `echo` on modern kernels. Always flag these.

### 8. rkhunter
```bash
apt install -y rkhunter
rkhunter --check --skip-keypress --report-warnings-only
```
**Known false positives:** snap users, hidden system config files, PermitRootLogin warnings.

### 9. ClamAV
```bash
apt install -y clamav
systemctl stop clamav-freshclam
rm -f /var/log/clamav/freshclam.log
freshclam --quiet
clamscan -r -i --max-scansize=100M /tmp /opt /root
```
Scans ~150K files, ~12 GB. Takes ~60 minutes. Production run: 0 infected files out of 144,868 scanned.

### 10. Lynis Security Score
```bash
apt install -y lynis
lynis audit system --quick | grep -E "Warning|Suggestion|Hardening"
```
Score 0–100. Production server: 65/100 → 72/100 after fixes.

### 11. Exposed Credentials
```bash
find /root -name "*key*" -o -name "*token*" -o -name "*secret*" -o -name "*pass*" -mtime -3
```
**Fix:** Move exposed keys to `~/.hermes/profiles/<name>/.env` with 600 permissions.

### 12. Network Connections
```bash
ss -tnp state established | grep -v "127.0.0.1\|::1" | awk '{print $5, $NF}' | sort -u
```
**Looks for:** C2 callbacks, suspicious outbound connections.

## Key Design Decisions

### Why a Skill, Not a Tool

Hermes skills are the right delivery mechanism because:
- **Zero setup** — `hermes skills install https://raw.githubusercontent.com/axelfreeman/hermes-security-audit/main/SKILL.md`
- **Self-documenting** — The skill content IS the instruction manual for the agent
- **Portable** — Works across all Hermes profiles and platforms
- **Triggerable** — Matches natural language ("check my server") without remembering CLI flags

### Why No Custom Scripts

The skill instructs the agent to run standard Linux commands directly. This is intentional:
- No compiled binaries to trust or maintain
- No dependency on a specific language runtime beyond bash
- Transparent — every command is visible to the user
- The agent interprets and contextualizes results (a script can't)

### False Positive Handling

Critical for trust. Each method documents common false positives:
- chkrootkit: `basename`, `date`, `dirname`, `echo` on kernel 5.x+
- rkhunter: snap users on Ubuntu, hidden `/etc/.resolv.conf` backup
- Process audit: `pool_workqueue_release` kernel threads, `apify-cli` node_modules

The skill teaches the agent to flag these as known false positives rather than alarms.

## Production Results

Real audit on a Hetzner VPS running Hermes Agent (Ubuntu 26.04, 3 profiles):

| Finding | Count | Severity | Fixed |
|---------|-------|----------|-------|
| SSH brute force attempts | 11,099 (across 3 servers) | CRITICAL | fail2ban installed |
| CUPS print service (port 631) | 1 | HIGH | Purged |
| SMTP relay (port 25) | 1 | HIGH | Disabled |
| VPN private keys in /root/ | 2 files | HIGH | Moved to protected dir |
| Orphan Xray SOCKS5 proxy | 1 process | MEDIUM | Killed |
| PermitRootLogin: yes | 1 | HIGH | Changed to prohibit-password |
| Lynis hardening score | 65/100 → 72/100 | INFO | +7 points |

## Maintaining This Skill

### Adding a Detection Method

1. Add the command block to `references/audit-methodology.md`
2. Document it in README.md (both EN and RU)
3. Update the 12-methods list in SKILL.md's description
4. Add new keywords to SEMANTICS.md if needed
5. Test on a Linux server — document false positives

### Updating YAML Frontmatter

The SKILL.md frontmatter controls discovery and behavior:
```yaml
triggers:        # Natural-language phrases that activate this skill
metadata.hermes: # Tags, cost, requirements, install method
```
After updating triggers, verify they don't collide with other skills. Test with `hermes skills inspect`.

### SEO & Discovery

SEMANTICS.md tracks keyword strategy. The README.md is optimized for:
- `hermes agent security audit`
- `ai agent antivirus`
- `check hermes agent malware`

When adding content, preserve keyword density in H1, first paragraph, and table headers.

## Development Conventions

- **Language:** Skill content is markdown + shell commands. No compiled code.
- **Compatibility:** Target Ubuntu 22.04+ (apt-based). All tools installable via apt.
- **Safety:** Never run destructive commands without user confirmation. The agent handles this via Hermes's approval system.
- **Secrets:** Never log or store credentials. The skill only reads — never writes — sensitive files.
- **Versioning:** Follow semver in SKILL.md frontmatter. Bump patch for fixes, minor for new methods, major for breaking trigger changes.
- **Bilingual:** All user-facing docs exist in EN and RU. Russian is primary (author is Russian-speaking).

## Testing

### Manual Test Flow
```bash
# Install the skill into a test Hermes profile
hermes skills install https://raw.githubusercontent.com/axelfreeman/hermes-security-audit/main/SKILL.md

# Trigger the audit
hermes -s hermes-security-audit chat -q "run a security audit on this server"

# Verify all 12 methods execute without errors
# Check that known false positives are correctly identified
```

### What to Verify
1. All 12 detection methods complete (check for timeouts on ClamAV — can take 60+ min)
2. False positives are flagged, not reported as threats
3. SSH brute force correctly parses auth.log
4. Port audit catches CUPS/SMTP when present
5. Exposed credential scan finds test keys
6. Lynis score is reported numerically
7. Multi-server SSH pattern works (if testing infrastructure)

## Publishing

```bash
# Changes are live immediately — SKILL.md is fetched from main
git add -A
git commit -m "fix: describe change"
git push origin main

# Verify
hermes skills install https://raw.githubusercontent.com/axelfreeman/hermes-security-audit/main/SKILL.md
```

## Related Hermes Agent Context

- This repo provides a **skill**, not a plugin or tool. It has no Python code, no dependencies, no build step.
- Skills are loaded from `~/.hermes/profiles/<name>/skills/` or from the hub.
- The `hermes-skills` directory convention groups this under `infrastructure/`.
- For Hermes Agent internals, see the `hermes-agent` skill and https://hermes-agent.nousresearch.com/docs/.
- Project context files (this AGENTS.md): loaded cwd-only, capped at 20,000 characters.

## License

MIT — use, modify, share freely. Part of [Axel Freeman's](https://github.com/axelfreeman) open-source toolkit.
