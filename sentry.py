import time
import requests

# Configuration
LOG_FILE = "/var/log/nginx/access.log"
WEBHOOK_URL = "https://canary.discord.com/api/webhooks/1459951341995692236/RH5aVDfiQNPVuLdUj8agyWf3Kj8x4YymGlq-iAXE46VimiCK9ZQP2YeOUTT5OhlNQIbe"
COOLDOWN_SECONDS = 60 

# This dictionary will store { "IP_ADDRESS": TIMESTAMP }
alert_history = {}

def monitor_logs():
    print("🛡️ Gatekeeper Sentry is active and intelligent...")
    with open(LOG_FILE, "r") as f:
        f.seek(0, 2)
        while True:
            line = f.readline()
            if not line:
                time.sleep(0.1)
                continue
            
            if " 404 " in line:
                ip = line.split()[0]
                path = line.split()[6]
                
                current_time = time.time()
                # Check if we should alert or if we are in cooldown
                last_alert_time = alert_history.get(ip, 0)
                
                if current_time - last_alert_time > COOLDOWN_SECONDS:
                    send_alert(ip, path)
                    alert_history[ip] = current_time # Update the last alert time
                else:
                    print(f"🤫 Suppressing repeat alert for {ip}")

def send_alert(ip, path):
    payload = {
        "content": f"🚨 **Intruder Alert!**\n**IP:** `{ip}`\n**Path:** `{path}`\n*(Cooldown active for 60s)*"
    }
    requests.post(WEBHOOK_URL, json=payload)

if __name__ == "__main__":
    monitor_logs()
