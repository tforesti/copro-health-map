module Api
  module V1
    class CoproprietesController < BaseController
      def index
        coproprietes = Copropriete.all
        coproprietes = coproprietes.where(code_officiel_commune: params[:code_officiel_commune]) if params[:code_officiel_commune].present?
        coproprietes = coproprietes.where(code_postal_adresse: params[:code_postal]) if params[:code_postal].present?
        coproprietes = coproprietes.where(risk_level: params[:risk_level]) if params[:risk_level].present?

        render json: coproprietes.by_score.map { |copropriete| serialize(copropriete) }
      end

      def show
        copropriete = Copropriete.find(params[:id])
        render json: serialize(copropriete)
      end

      private

      def serialize(copropriete)
        copropriete.as_json(
          only: %i[
            id numero_immatriculation nom_usage_copropriete
            adresse_reference numero_voie_adresse code_postal_adresse commune_adresse
            code_officiel_commune longitude latitude
            type_syndic syndicat_cooperatif mandat_en_cours
            raison_sociale_representant_legal
            nombre_total_lots nombre_lots_habitation periode_construction
            copro_aidee copro_dans_acv copro_dans_pvd copro_dans_pdp
            total_score risk_level reasons
          ]
        )
      end
    end
  end
end
