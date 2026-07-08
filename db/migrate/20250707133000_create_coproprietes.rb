class CreateCoproprietes < ActiveRecord::Migration[8.1]
  def change
    create_table :coproprietes do |t|
      t.string :numero_immatriculation, null: false
      t.string :nom_usage_copropriete
      t.date :date_immatriculation
      t.date :date_derniere_maj
      t.date :date_reglement_copropriete

      t.string :epci
      t.string :commune
      t.string :adresse_reference
      t.string :numero_voie_adresse
      t.string :code_postal_adresse
      t.string :commune_adresse
      t.string :code_officiel_commune
      t.decimal :longitude, precision: 10, scale: 7
      t.decimal :latitude, precision: 10, scale: 7

      t.string :type_syndic
      t.boolean :syndicat_cooperatif, default: false, null: false
      t.boolean :mandat_en_cours, default: false, null: false
      t.date :date_fin_dernier_mandat
      t.string :raison_sociale_representant_legal
      t.string :siret_representant_legal

      t.integer :nombre_total_lots
      t.integer :nombre_lots_habitation
      t.integer :nombre_lots_stationnement
      t.integer :nombre_lots_habitation_bureaux_commerces
      t.string :periode_construction

      t.boolean :copro_aidee, default: false, null: false
      t.boolean :copro_dans_acv, default: false, null: false
      t.boolean :copro_dans_pvd, default: false, null: false
      t.boolean :copro_dans_pdp, default: false, null: false

      t.integer :total_score
      t.string :risk_level
      t.json :reasons, null: false, default: []

      t.timestamps
    end

    add_index :coproprietes, :numero_immatriculation, unique: true
    add_index :coproprietes, :code_officiel_commune
    add_index :coproprietes, :risk_level
    add_index :coproprietes, :total_score
  end
end
