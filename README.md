# POC Copro Health Map

Carte des copropriétés de Lyon et score de santé estimé à partir des données ouvertes **RNC (ANAH)**.
https://copro-health-map.tf89.fr/

## Stack

- **Backend** : Ruby on Rails 8, PostgreSQL
- **Frontend** : React, TypeScript, Vite, Leaflet

## Lancer en local

Voir [docs/rnc-import.md](docs/rnc-import.md).

```bash
bin/rails db:migrate
bin/rails import:rnc[/chemin/vers/rnc.csv]
bin/rails server

cd frontend && npm install && npm run dev
# → http://localhost:5173
```

## Score de santé

Heuristique sur les données RNC disponibles en open data (pas d'impayés réels). Voir `app/services/health_score_calculator.rb`.
