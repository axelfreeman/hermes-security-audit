// dsh skill plugin — registers the skill from SKILL.md (name + description + body).
import { readFileSync } from 'node:fs'

const NAME = "hermes-security-audit"
const DESCRIPTION = "Free security audit for Linux servers \u2014 no API keys, no paid tools. Scans for viruses (ClamAV), rootkits (rkhunter + chkrootkit), SSH brute force, crypto miners, exposed credentials, and open ports. 12 detection methods, proven on production (11,000+ attacks found and blocked). Use when the user asks to audit or harden a Linux server, check for malware/rootkits/crypto miners, scan open ports, or detect SSH brute force \u2014 \"security audit\", \"check for malware\"."

export const name = NAME

export function apply(ctx) {
  const raw = readFileSync(new URL('./SKILL.md', import.meta.url), 'utf8')
  const content = raw.replace(/^---[^\n]*\n[\s\S]*?\n---\s*\n?/, '').trim()
  ctx.skills.register({ name: NAME, description: DESCRIPTION, source: 'runtime', content })
}
