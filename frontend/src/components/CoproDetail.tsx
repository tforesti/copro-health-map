import type { Copropriete } from '../types/copropriete'
import { RISK_COLORS, RISK_LABELS, TERRITORIAL_CONTEXT_LABELS } from '../types/copropriete'

interface CoproDetailProps {
  copropriete: Copropriete | null
}

export function CoproDetail({ copropriete }: CoproDetailProps) {
  if (!copropriete) {
    return (
      <div className="copro-detail empty">
        Sélectionnez une copropriété sur la carte ou dans la liste.
      </div>
    )
  }

  const color = copropriete.risk_level ? RISK_COLORS[copropriete.risk_level] : '#94a3b8'

  return (
    <div className="copro-detail">
      <div className="copro-detail-header">
        <div>
          <h2>{copropriete.nom_usage_copropriete || copropriete.adresse_reference}</h2>
          <p>
            {copropriete.numero_voie_adresse}, {copropriete.code_postal_adresse}{' '}
            {copropriete.commune_adresse}
          </p>
        </div>
        <div className="copro-detail-score">
          <span style={{ color }}>{copropriete.total_score ?? '—'}</span>
          <small>{copropriete.risk_level ? RISK_LABELS[copropriete.risk_level] : 'Non évaluée'}</small>
        </div>
      </div>

      <div className="copro-detail-grid">
        <Info label="Immatriculation" value={copropriete.numero_immatriculation} />
        <Info label="Lots" value={String(copropriete.nombre_total_lots ?? '—')} />
        <Info label="Construction" value={copropriete.periode_construction ?? '—'} />
        <Info label="Syndic" value={copropriete.type_syndic ?? '—'} />
      </div>

      <TerritorialContext copropriete={copropriete} />

      <div className="copro-detail-reasons">
        <h3>Facteurs de score</h3>
        <ul>
          {(copropriete.reasons?.length ? copropriete.reasons : ['Aucun signal particulier']).map(
            (reason) => (
              <li key={reason}>{reason}</li>
            ),
          )}
        </ul>
      </div>
    </div>
  )
}

function TerritorialContext({ copropriete }: { copropriete: Copropriete }) {
  const flags = [
    copropriete.copro_dans_acv && TERRITORIAL_CONTEXT_LABELS.acv,
    copropriete.copro_dans_pvd && TERRITORIAL_CONTEXT_LABELS.pvd,
    copropriete.copro_dans_pdp && TERRITORIAL_CONTEXT_LABELS.pdp,
  ].filter(Boolean) as string[]

  return (
    <div className="copro-detail-context">
      <h3>Contexte territorial</h3>
      {flags.length ? (
        <ul className="copro-detail-context-list">
          {flags.map((label) => (
            <li key={label}>{label}</li>
          ))}
        </ul>
      ) : (
        <p className="copro-detail-context-none">Aucun dispositif territorial recensé</p>
      )}
    </div>
  )
}

function Info({ label, value }: { label: string; value: string }) {
  return (
    <div className="copro-info">
      <span>{label}</span>
      <strong>{value}</strong>
    </div>
  )
}
