import type { Copropriete } from '../types/copropriete'
import { RISK_COLORS, RISK_LABELS } from '../types/copropriete'

interface CoproListProps {
  coproprietes: Copropriete[]
  selectedId: number | null
  onSelect: (id: number) => void
}

export function CoproList({ coproprietes, selectedId, onSelect }: CoproListProps) {
  return (
    <div className="copro-list">
      {coproprietes.map((copro) => {
        const isSelected = copro.id === selectedId
        const color = copro.risk_level ? RISK_COLORS[copro.risk_level] : '#94a3b8'

        return (
          <button
            key={copro.id}
            type="button"
            className={`copro-list-item${isSelected ? ' selected' : ''}`}
            onClick={() => onSelect(copro.id)}
          >
            <div className="copro-list-header">
              <div>
                <p className="copro-list-title">
                  {copro.nom_usage_copropriete || copro.adresse_reference || 'Sans nom'}
                </p>
                <p className="copro-list-subtitle">
                  {copro.numero_voie_adresse} {copro.commune_adresse}
                </p>
              </div>
              <span className="copro-score-badge" style={{ backgroundColor: color }}>
                {copro.total_score ?? '—'}
              </span>
            </div>
            <p className="copro-list-risk">
              {copro.risk_level ? RISK_LABELS[copro.risk_level] : 'Non évaluée'}
            </p>
          </button>
        )
      })}
    </div>
  )
}
