# 🔒 Аудит безопасности Hermes Agent

**12 методов проверки безопасности вашего AI-агента за 5 минут.**

Если вы используете Hermes Agent на своём сервере — этот скилл проверит его на вирусы, руткиты, майнеры, брутфорс SSH и другие угрозы.

## Что проверяем

| Метод | Что находит |
|-------|------------|
| **Анализ портов** | Открытые TCP/UDP, скрытые сервисы |
| **Аудит процессов** | Майнеры, подозрительные процессы |
| **SSH брутфорс** | Кто ломится на сервер |
| **SUID/SGID файлы** | Векторы повышения привилегий |
| **Cron-задачи** | Скрытые задачи всех пользователей |
| **Docker аудит** | Контейнеры, порты, привилегии |
| **chkrootkit** | Руткиты (сигнатурный анализ) |
| **rkhunter** | Руткиты + бэкдоры |
| **ClamAV** | Антивирусная проверка |
| **Lynis** | Комплексный аудит (hardening index) |
| **Файлы с ключами** | Открытые API-ключи, пароли |
| **Сетевые соединения** | Исходящий трафик в интернет |

## Быстрый старт

```bash
# Клонируем репозиторий
git clone https://github.com/axelfreeman/hermes-security-audit.git
cd hermes-security-audit

# Запускаем аудит
hermes skill load hermes-security-audit
```

## Типичные находки

| Проблема | Решение |
|---------|---------|
| PermitRootLogin yes | `sed -i 's/PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config` |
| CUPS (печать) на сервере | `systemctl stop cups && apt purge -y cups` |
| SMTP открыт | `systemctl stop postfix` |
| SSH брутфорс | `apt install -y fail2ban` |
| Ключи в /root/ | Перенести в `~/.hermes/profiles/<name>/.env` |
| Xray/прокси висят | `kill $(ss -tlnp | grep <PORT> | grep -oP 'pid=\K\d+')` |
| Криптомайнеры | `docker rm -f <container>; rm -rf /opt/<project>` |

## Результаты

После первого аудита на production-сервере:
- ✅ 0 криптомайнеров
- ✅ Hardening index: 65/100
- ❌ 3,194 SSH атак (забанены fail2ban)
- ❌ CUPS, SMTP удалены
- ❌ VPN ключи спрятаны

## Ключевые слова (SEO)

`проверка hermes agent на вирусы`, `аудит безопасности hermes агента`, `антивирус для ai агента`, `проверка безопасности hermes`, `защита hermes агента от взлома`, `сканер уязвимостей hermes agent`, `безопасность ai ассистента`, `как проверить hermes на вирусы`

## Лицензия

MIT — используйте свободно.
