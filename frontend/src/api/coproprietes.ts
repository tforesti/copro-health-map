import type { Copropriete } from '../types/copropriete'

export async function fetchCoproprietes(params?: {
  risk_level?: string
  code_postal?: string
}): Promise<Copropriete[]> {
  const search = new URLSearchParams()
  if (params?.risk_level) search.set('risk_level', params.risk_level)
  if (params?.code_postal) search.set('code_postal', params.code_postal)

  const query = search.toString()
  const response = await fetch(`/api/v1/coproprietes${query ? `?${query}` : ''}`)

  if (!response.ok) {
    throw new Error('Impossible de charger les copropriétés')
  }

  return response.json()
}

export async function fetchCopropriete(id: number): Promise<Copropriete> {
  const response = await fetch(`/api/v1/coproprietes/${id}`)

  if (!response.ok) {
    throw new Error('Copropriété introuvable')
  }

  return response.json()
}
