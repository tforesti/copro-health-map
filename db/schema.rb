# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_07_07_133000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "coproprietes", force: :cascade do |t|
    t.string "adresse_reference"
    t.string "code_officiel_commune"
    t.string "code_postal_adresse"
    t.string "commune"
    t.string "commune_adresse"
    t.boolean "copro_aidee", default: false, null: false
    t.boolean "copro_dans_acv", default: false, null: false
    t.boolean "copro_dans_pdp", default: false, null: false
    t.boolean "copro_dans_pvd", default: false, null: false
    t.datetime "created_at", null: false
    t.date "date_derniere_maj"
    t.date "date_fin_dernier_mandat"
    t.date "date_immatriculation"
    t.date "date_reglement_copropriete"
    t.string "epci"
    t.decimal "latitude", precision: 10, scale: 7
    t.decimal "longitude", precision: 10, scale: 7
    t.boolean "mandat_en_cours", default: false, null: false
    t.string "nom_usage_copropriete"
    t.integer "nombre_lots_habitation"
    t.integer "nombre_lots_habitation_bureaux_commerces"
    t.integer "nombre_lots_stationnement"
    t.integer "nombre_total_lots"
    t.string "numero_immatriculation", null: false
    t.string "numero_voie_adresse"
    t.string "periode_construction"
    t.string "raison_sociale_representant_legal"
    t.json "reasons", default: [], null: false
    t.string "risk_level"
    t.string "siret_representant_legal"
    t.boolean "syndicat_cooperatif", default: false, null: false
    t.integer "total_score"
    t.string "type_syndic"
    t.datetime "updated_at", null: false
    t.index ["code_officiel_commune"], name: "index_coproprietes_on_code_officiel_commune"
    t.index ["numero_immatriculation"], name: "index_coproprietes_on_numero_immatriculation", unique: true
    t.index ["risk_level"], name: "index_coproprietes_on_risk_level"
    t.index ["total_score"], name: "index_coproprietes_on_total_score"
  end
end
