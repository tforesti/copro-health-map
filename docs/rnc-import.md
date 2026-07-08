# Import RNC (ANAH)

## Colonnes importées

Identité, adresse, syndic, lots, période de construction, aides ANAH (`copro_aidee`) et contexte territorial (`copro_dans_acv`, `copro_dans_pvd`, `copro_dans_pdp`).

## Commande

```bash
bin/rails db:migrate
bin/rails import:rnc[/chemin/vers/ton-fichier-rnc.csv]
```

Par défaut, filtre sur les 9 arrondissements de Lyon (`69001` à `69009`).

## Filtrer d'autres communes

```bash
COMMUNE_CODES=69266 bin/rails import:rnc[/chemin/vers/rnc.csv]
```

(`69266` = Villeurbanne)

## Recalculer les scores

Les scores sont calculés automatiquement à l'import (`before_validation` sur `Copropriete`).

Pour recalculer après une modification de l'algorithme :

```bash
bin/rails coproprietes:recalculate_scores
```

## Source

Registre National d'Immatriculation des Copropriétés — [data.gouv.fr](https://www.data.gouv.fr/datasets/registre-national-dimmatriculation-des-coproprietes)
