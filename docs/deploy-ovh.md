# Déploiement sur VPS OVH

Architecture : **Nginx** (VPS, repo **tf89-infra**) → **Docker Compose** (ce repo) → Postgres + Rails + React.

- POC : `https://copro-health-map.tf89.fr` → `127.0.0.1:8080`
- Site statique : `tf89.fr` → géré par **tf89-infra**

## 1. DNS

Enregistrements attendus dans la zone `tf89.fr` :

| Type | Sous-domaine | Cible |
|------|--------------|-------|
| A | `copro-health-map` | IP du VPS |
| A | `@` | IP du VPS |
| A | `www` | IP du VPS (optionnel) |

```bash
dig +short copro-health-map.tf89.fr A
```

## 2. Bootstrap VPS (tf89-infra)

Le serveur (Docker, UFW, Nginx, HTTPS) est provisionné via Ansible dans le repo **tf89-infra** — pas dans ce repo.

```bash
cd ~/Projects/ai-open/tf89-infra/ansible
cp inventory.yml.example inventory.yml
cp group_vars/all.yml.example group_vars/all.yml
# éditer IP + domaines

ansible-galaxy collection install -r requirements.yml
ansible-playbook site.yml
```

Voir le README de tf89-infra pour l'ordre complet (HTTP d'abord, Certbot après déploiement de l'app).

## 3. Déployer l'application (tf89-infra)

```bash
cd ~/Projects/ai-open/tf89-infra/ansible
cp group_vars/copro_health_map.yml.example group_vars/copro_health_map.yml
cp group_vars/secrets.yml.example group_vars/secrets.yml
# éditer : repo Git, POSTGRES_PASSWORD, RAILS_MASTER_KEY (config/master.key en local)

ansible-playbook deploy-copro.yml --ask-pass --ask-become-pass
curl -s http://copro-health-map.tf89.fr/up
```

Déploiement manuel possible : clone dans `/srv/apps/copro-health-map`, `.env`, `docker compose up -d --build`.

## 4. HTTPS

Une fois l'app répond en HTTP :

```bash
# dans tf89-infra : renseigner certbot_email dans group_vars/all.yml
ansible-playbook site.yml --tags nginx
```

## 5. Importer les données RNC

```bash
# depuis ta machine locale
scp /chemin/vers/rnc.csv debian@IP_DU_VPS:/tmp/rnc.csv

# sur le VPS
docker compose exec api bin/rails import:rnc[/tmp/rnc.csv]
```

## 6. Commandes utiles

```bash
docker compose logs -f api
docker compose exec api bin/rails coproprietes:recalculate_scores
docker compose exec api bin/rails console
docker compose up -d --build   # après git pull
```

## Ports locaux (convention tf89-infra)

| Port | Service |
|------|---------|
| 8080 | copro-health-map |
| 8081 | prochain projet… |
