require "csv"

class RncImporter
  LYON_CODES = Copropriete.lyon_arrondissement_codes.freeze

  def self.call(path:, commune_codes: LYON_CODES)
    new(path:, commune_codes:).call
  end

  def initialize(path:, commune_codes:)
    @path = path
    @commune_codes = commune_codes.map(&:to_s)
  end

  def call
    raise ArgumentError, "Fichier introuvable: #{path}" unless File.exist?(path)

    imported = 0
    skipped = 0

    CSV.foreach(path, headers: true, liberal_parsing: true) do |row|
      unless commune_codes.include?(row["code_officiel_commune"].to_s)
        skipped += 1
        next
      end

      upsert_from_row(row)
      imported += 1
    end

    { imported:, skipped: }
  end

  private

  attr_reader :path, :commune_codes

  def upsert_from_row(row)
    numero = row["numero_immatriculation"].to_s.strip
    return if numero.blank?

    copropriete = Copropriete.find_or_initialize_by(numero_immatriculation: numero)
    copropriete.assign_attributes(mapped_attributes(row))
    copropriete.save!
  end

  def mapped_attributes(row)
    {
      epci: row["epci"],
      commune: row["commune"],
      nom_usage_copropriete: row["nom_usage_copropriete"],
      date_immatriculation: parse_date(row["date_immatriculation"]),
      date_derniere_maj: parse_date(row["date_derniere_maj"]),
      date_reglement_copropriete: parse_date(row["date_reglement_copropriete"]),
      adresse_reference: row["adresse_reference"],
      numero_voie_adresse: row["numero_voie_adresse"],
      code_postal_adresse: row["code_postal_adresse"],
      commune_adresse: row["commune_adresse"],
      code_officiel_commune: row["code_officiel_commune"],
      longitude: parse_decimal(row["longitude"]),
      latitude: parse_decimal(row["latitude"]),
      type_syndic: row["type_syndic"],
      syndicat_cooperatif: parse_boolean(row["syndicat_cooperatif"]),
      mandat_en_cours: parse_boolean(row["mandat_en_cours"]),
      date_fin_dernier_mandat: parse_date(row["date_fin_dernier_mandat"]),
      raison_sociale_representant_legal: row["raison_sociale_representant_legal"],
      siret_representant_legal: row["siret_representant_legal"],
      nombre_total_lots: parse_integer(row["nombre_total_lots"]),
      nombre_lots_habitation: parse_integer(row["nombre_lots_habitation"]),
      nombre_lots_stationnement: parse_integer(row["nombre_lots_stationnement"]),
      nombre_lots_habitation_bureaux_commerces: parse_integer(row["nombre_lots_habitation_bureaux_commerces"]),
      periode_construction: row["periode_construction"],
      copro_aidee: parse_boolean(row["copro_aidee"]),
      copro_dans_acv: parse_boolean(row["copro_dans_acv"]),
      copro_dans_pvd: parse_boolean(row["copro_dans_pvd"]),
      copro_dans_pdp: parse_boolean(row["copro_dans_pdp"])
    }
  end

  def parse_boolean(value)
    normalized = value.to_s.strip.downcase
    return false if normalized.blank?
    return true if %w[true 1 oui yes o].include?(normalized)

    false
  end

  def parse_integer(value)
    return nil if value.blank?

    Integer(value)
  rescue ArgumentError
    nil
  end

  def parse_decimal(value)
    return nil if value.blank?

    BigDecimal(value.to_s.tr(",", "."))
  rescue ArgumentError
    nil
  end

  def parse_date(value)
    return nil if value.blank?

    Date.parse(value)
  rescue Date::Error
    nil
  end
end
