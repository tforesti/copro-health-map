# Copro Health Map

POC — carte des copropriétés de Lyon, score de santé estimé à partir des données ouvertes **RNC (ANAH)**.

Projet portfolio en marge d'une candidature [Matera](https://matera.eu).

## Stack

- **Backend** : Ruby on Rails 8, PostgreSQL, import CSV RNC
- **Frontend** : React, TypeScript, Vite, TanStack Query, Leaflet

## Démo locale

Voir [docs/development-setup.md](docs/development-setup.md) et [docs/rnc-import.md](docs/rnc-import.md).

```bash
bin/rails db:migrate
bin/rails import:rnc[/chemin/vers/rnc.csv]
bin/rails server

cd frontend && npm install && npm run dev
# → http://localhost:5173
```

## Déploiement VPS OVH

Guide complet : **[docs/deploy-ovh.md](docs/deploy-ovh.md)**

```bash
cp .env.example .env   # RAILS_MASTER_KEY, POSTGRES_PASSWORD
docker compose up -d --build
```

- Site : `http://IP_DU_VPS`
- API : `http://IP_DU_VPS/api/v1/coproprietes`

## Score de santé

Heuristique sur données RNC (pas d'impayés réels en open data). Voir `app/services/health_score_calculator.rb`.

## Licence

MIT — projet portfolio personnel.
