export type RiskLevel = 'healthy' | 'watch' | 'critical'

export interface Copropriete {
  id: number
  numero_immatriculation: string
  nom_usage_copropriete: string | null
  adresse_reference: string | null
  numero_voie_adresse: string | null
  code_postal_adresse: string | null
  commune_adresse: string | null
  code_officiel_commune: string | null
  longitude: string | null
  latitude: string | null
  type_syndic: string | null
  syndicat_cooperatif: boolean
  mandat_en_cours: boolean
  raison_sociale_representant_legal: string | null
  nombre_total_lots: number | null
  nombre_lots_habitation: number | null
  periode_construction: string | null
  copro_aidee: boolean
  copro_dans_acv: boolean
  copro_dans_pvd: boolean
  copro_dans_pdp: boolean
  total_score: number | null
  risk_level: RiskLevel | null
  reasons: string[]
}

export const RISK_COLORS: Record<RiskLevel, string> = {
  healthy: '#22c55e',
  watch: '#f59e0b',
  critical: '#ef4444',
}

export const RISK_LABELS: Record<RiskLevel, string> = {
  healthy: 'Saine',
  watch: 'À surveiller',
  critical: 'À risque',
}

export const TERRITORIAL_CONTEXT_LABELS = {
  acv: 'Action Cœur de Ville',
  pvd: 'Petites Villes de Demain',
  pdp: 'Périmètre de déploiement prioritaire (réseau de chaleur/froid)',
} as const
