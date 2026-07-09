# Copro Health Map — guide agent

POC portfolio : carte des copropriétés de Lyon, score de santé estimé depuis les données ouvertes RNC (ANAH).

Démo : https://copro-health-map.tf89.fr/

## Architecture

- **Backend** : Rails 8 API-only, PostgreSQL, Puma
- **Frontend** : React + TypeScript + Vite + TanStack Query + Leaflet (`frontend/`)
- **Prod** : Docker Compose (db + api + web/nginx) derrière Nginx du VPS — voir repo `tf89-infra`

```
CSV RNC → RncImporter → Copropriete (model)
                              ↓ before_validation
                    HealthScoreCalculator
                              ↓
              API JSON /api/v1/coproprietes → React (carte + liste)
```

## Fichiers clés

| Fichier | Rôle |
|---------|------|
| `app/models/copropriete.rb` | Modèle, validations, callback score |
| `app/services/health_score_calculator.rb` | Heuristique score / risk_level / reasons |
| `app/services/rnc_importer.rb` | Import CSV, filtre communes, upsert |
| `lib/tasks/import_rnc.rake` | Tâche `bin/rails import:rnc[path]` |
| `app/controllers/api/v1/coproprietes_controller.rb` | API REST (index, show) |
| `frontend/src/App.tsx` | État UI, TanStack Query, layout |
| `frontend/src/components/CoproMap.tsx` | Carte Leaflet, CircleMarker |
| `frontend/src/components/CoproDetail.tsx` | Détail copro + facteurs de score |

## Domaine RNC (important)

- `copro_dans_pdp` = **périmètre de déploiement prioritaire** (réseaux chaleur/froid), **pas** plan de sauvegarde (PDS)
- `copro_dans_acv` / `copro_dans_pvd` = programmes de revitalisation territoriale
- Pas d'impayés en open data → le score est une **heuristique**, le dire clairement dans l'UI et la doc
- Filtre import par défaut : arrondissements Lyon `69001`–`69009` (`COMMUNE_CODES` pour changer)

## Conventions code

- Logique métier dans `app/services/` avec pattern `self.call`
- API JSON via `as_json(only: [...])` — pas de serializers, pas de vues
- Score recalculé dans `before_validation` sur `Copropriete`
- Front React séparé — ne pas migrer vers Hotwire pour l'UI principale
- Changements minimaux, pas de sur-ingénierie

## Commandes utiles

```bash
bin/rails db:migrate
bin/rails import:rnc[/chemin/vers/rnc.csv]
bin/rails coproprietes:recalculate_scores
bin/rails server

cd frontend && npm run dev
docker compose up -d --build
```

## Ne pas

- Remettre l'infra VPS (Nginx, Ansible, Certbot) dans ce repo — c'est `tf89-infra`
- Confondre PDP / PDS / ACV / PVD dans les labels ou le score
- Ajouter une pénalité score pour `copro_dans_pdp` (c'est un contexte territorial, pas un signal de santé)
- Committer `config/master.key`, `.env`, ou des secrets

## Déploiement

Géré par `tf89-infra` (`deploy-copro.yml`). Ce repo ne contient que l'app et son `docker-compose.yml`.
