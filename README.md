# rteam-fze — Odoo 19 Community Deployment

Docker Compose deployment for **Odoo 19 Community Edition** on a Hetzner VPS.

## Stack

| Service | Image | Port |
|---------|-------|------|
| Odoo 19 CE | `odoo:19.0` | 8069 (internal) |
| PostgreSQL 15 | `postgres:15` | 5432 (internal) |
| Nginx | `nginx:alpine` | 80 (public) |

---

## Quick Start (on the server)

### 1. Clone and bootstrap

```bash
git clone https://github.com/alex-odoo/rteam-fze.git /opt/rteam-fze
cd /opt/rteam-fze
```

### 2. Configure environment

```bash
cp .env.example .env
nano .env   # Set strong passwords
```

### 3. Start services

```bash
docker compose up -d
docker compose ps        # verify all 3 containers are "Up"
docker compose logs -f odoo   # watch startup logs
```

### 4. Open Odoo

Navigate to `http://<YOUR_SERVER_IP>` in your browser.
You will see the **database creation screen** on first run.

Fill in:
- **Master Password**: the `ODOO_ADMIN_PASSWD` you set in `.env`
- **Database Name**: anything (e.g. `rteam`)
- **Email / Password**: your admin login

---

## Environment Variables (`.env`)

| Variable | Description |
|----------|-------------|
| `POSTGRES_DB` | Database name (default: `odoo`) |
| `POSTGRES_USER` | DB username (default: `odoo`) |
| `POSTGRES_PASSWORD` | **Change this!** DB password |
| `ODOO_ADMIN_PASSWD` | **Change this!** Odoo master password |

---

## Custom Addons

Drop your custom Odoo modules into the `addons/` folder:

```
addons/
  my_module/
    __manifest__.py
    __init__.py
    ...
```

Then restart Odoo and install via **Apps → Update Apps List**:

```bash
docker compose restart odoo
```

---

## Backup

Run manually:

```bash
bash scripts/backup.sh
```

Schedule daily at 2 AM:

```bash
crontab -e
# Add:
0 2 * * * /opt/rteam-fze/scripts/backup.sh >> /var/log/odoo-backup.log 2>&1
```

Backups are stored in `/opt/rteam-fze/backups/` and kept for 7 days.

---

## Update Odoo

```bash
cd /opt/rteam-fze
git pull
docker compose pull
docker compose up -d
```

---

## Adding SSL (later)

Once you have a domain pointing to this server:

1. Add Certbot to `docker-compose.yml`
2. Update `nginx/nginx.conf` with HTTPS server block
3. Add HTTP → HTTPS redirect

---

## Server Provisioning (Hetzner)

See the provisioning commands in the project plan or run:

```bash
hcloud server create \
  --name rteam-odoo \
  --type cx22 \
  --image ubuntu-22.04 \
  --ssh-key <your-key-name> \
  --firewall rteam-fw \
  --location nbg1
```
