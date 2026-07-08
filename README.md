# Copro Health Map

POC perso — carte des copropriétés scorées selon leur « santé » (financier, technique, gouvernance, opérationnel).

Projet d'exploration en marge d'une candidature [Matera](https://matera.eu). Données fictives (Lyon).

## Stack

- **Backend** : Ruby on Rails 8 (API), SQLite (dev), PostgreSQL (prod)
- **Frontend** : React, TypeScript, Vite, TanStack Query, Leaflet, Tailwind CSS
- **Tests** : RSpec (calculateur de score + API)

## Démo locale

Voir **[docs/development-setup.md](docs/development-setup.md)** pour l’installation propre (rbenv, Ruby 4.0.5).

### Prérequis

- **rbenv** + Ruby 4.0.5 (voir guide ci-dessus)
- Node.js 20+

### Backend

```bash
cd backend
bin/setup          # bundle install + db:prepare + db:seed
bin/rails server
```

API : http://localhost:3000/api/v1/coproprietes

### Frontend

```bash
cd frontend
npm install
npm run dev
```

App : http://localhost:5173

## Score de santé (MVP)

Score sur 100 (100 = bonne santé) :

```
score = 100 - (0.35×financier + 0.30×technique + 0.20×gouvernance + 0.15×opérationnel)
```

Seuils :

- **70–100** : saine
- **40–69** : à surveiller
- **0–39** : à risque

## Déploiement OVH (Docker)

```bash
docker compose up -d --build
```

- Frontend : http://localhost (Nginx)
- API : http://localhost/api/v1/coproprietes

Variables utiles (`.env`) :

```
POSTGRES_PASSWORD=changeme
CORS_ORIGINS=https://votre-domaine.fr
RAILS_MASTER_KEY=<voir backend/config/master.key>
```

## Structure

```
backend/   Rails API + HealthScoreCalculator
frontend/  React SPA
docker-compose.yml
```

## Limites / V2

- Données seed fictives
- Pas d'authentification
- Pas d'import Registre National des Copropriétés (RNC)
- Filtres avancés, alertes, recalcul batch

## Licence

MIT — projet portfolio personnel.
