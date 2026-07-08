class HealthScoreCalculator
  Result = Data.define(:total_score, :risk_level, :reasons)

  CONSTRUCTION_PENALTIES = {
    /avant 1949/i => 25,
    /1949/i => 20,
    /1975/i => 10,
    /1994/i => 5
  }.freeze

  def self.call(copropriete)
    new(copropriete).call
  end

  def initialize(copropriete)
    @copropriete = copropriete
  end

  def call
    penalty = 0
    reasons = []

    if copropriete.copro_aidee?
      penalty += 25
      reasons << "Copropriété accompagnée par l'ANAH"
    end

    unless copropriete.mandat_en_cours?
      penalty += 15
      reasons << "Aucun mandat de syndic en cours"
    end

    construction_penalty = penalty_for_construction(copropriete.periode_construction)
    if construction_penalty.positive?
      penalty += construction_penalty
      reasons << "Période de construction à risque (#{copropriete.periode_construction})"
    end

    lots_penalty = penalty_for_lots(copropriete.nombre_total_lots)
    if lots_penalty.positive?
      penalty += lots_penalty
      reasons << "Copropriété de grande taille (#{copropriete.nombre_total_lots} lots)"
    end

    if copropriete.copro_dans_acv? || copropriete.copro_dans_pvd?
      penalty += 5
      reasons << "Commune dans un programme de revitalisation (ACV ou PVD)"
    end

    total_score = (100 - penalty).clamp(0, 100)

    Result.new(
      total_score: total_score,
      risk_level: risk_level_for(total_score),
      reasons: reasons.presence || [ "Situation globalement stable selon les données RNC" ]
    )
  end

  private

  attr_reader :copropriete

  def penalty_for_construction(period)
    return 0 if period.blank?

    CONSTRUCTION_PENALTIES.each do |pattern, value|
      return value if period.match?(pattern)
    end

    0
  end

  def penalty_for_lots(count)
    return 0 if count.blank?

    return 15 if count >= 100
    return 10 if count >= 50
    return 5 if count >= 30

    0
  end

  def risk_level_for(score)
    return "healthy" if score >= 70
    return "watch" if score >= 40

    "critical"
  end
end
