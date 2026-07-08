class Copropriete < ApplicationRecord
  RISK_LEVELS = %w[healthy watch critical].freeze

  validates :numero_immatriculation, presence: true, uniqueness: true
  validates :risk_level, inclusion: { in: RISK_LEVELS }, allow_nil: true

  before_validation :compute_health_score

  scope :by_score, -> { order(total_score: :asc) }
  scope :in_communes, ->(codes) { where(code_officiel_commune: codes) }

  def self.lyon_arrondissement_codes
    %w[69001 69002 69003 69004 69005 69006 69007 69008 69009]
  end

  private

  def compute_health_score
    result = HealthScoreCalculator.call(self)
    self.total_score = result.total_score
    self.risk_level = result.risk_level
    self.reasons = result.reasons
  end
end
