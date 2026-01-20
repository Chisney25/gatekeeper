# Project Gatekeeper: The Self-Defending Web Server

Gatekeeper is a secure Nginx web server implementation designed to serve custom content while actively monitoring for unauthorized access attempts.

## Features
- **Custom Nginx Engine:** Configured to serve a brand-identity home page and a custom **404 Guardian** page.
- **Active Sentry (IPS):** A Python-based monitoring service that parses access logs in real-time.
- **Intelligent Alerting:** Features cooldown logic to prevent notification spam during brute-force attempts.
- **Discord Integration:** Sends instant alerts to a security channel when a 404 trigger is detected.
- **Daemonized Service:** Runs as a persistent `systemd` background process.

## Project Structure
- `index.html`: The main web gateway.
- `custom_404.html`: The "Guardian" page for unauthorized paths.
- `sentry.py`: The Python monitoring logic.
- `gatekeeper-sentry.service`: The Linux system service configuration.

## Installation & Setup
1. **Nginx:** Move the site config to `/etc/nginx/sites-available/` and symlink to `sites-enabled`.
2. **Sentry:** - Install dependencies: `pip install requests`
   - Update `WEBHOOK_URL` in `sentry.py`.
3. **Service:**
   - Copy `gatekeeper-sentry.service` to `/etc/systemd/system/`.
   - Run `sudo systemctl enable --now gatekeeper-sentry`.

## Monitoring in Action
When a user attempts to access a non-existent path, Nginx logs a 404, the Sentry script detects the entry, and a notification is dispatched to Discord with the offender's IP and attempted path.

<img width="960" height="261" alt="Gatekeeper log monitor sentry" src="https://github.com/user-attachments/assets/3e1aaa43-97a0-430d-81e9-2dd03c013800" />

<img width="677" height="107" alt="System-Guardian Intruder Alert" src="https://github.com/user-attachments/assets/c246a41a-9cc9-4c3a-95fa-72185795884a" />

<img width="680" height="243" alt="intelligence_report" src="https://github.com/user-attachments/assets/9f0a7179-b0c3-4821-8fcf-359931fc7031" />


