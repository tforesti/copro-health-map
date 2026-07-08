import { useMemo, useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { fetchCoproprietes } from './api/coproprietes'
import { CoproList } from './components/CoproList'
import { CoproMap } from './components/CoproMap'
import { CoproDetail } from './components/CoproDetail'
import 'leaflet/dist/leaflet.css'
import './App.css'

function App() {
  const [selectedId, setSelectedId] = useState<number | null>(null)
  const [riskFilter, setRiskFilter] = useState('')

  const { data = [], isLoading, error } = useQuery({
    queryKey: ['coproprietes', riskFilter],
    queryFn: () => fetchCoproprietes(riskFilter ? { risk_level: riskFilter } : undefined),
  })

  const selected = useMemo(
    () => data.find((copro) => copro.id === selectedId) ?? null,
    [data, selectedId],
  )

  return (
    <div className="app">
      <header className="app-header">
        <div>
          <h1>Copro Health Map</h1>
          <p>Données RNC (ANAH) — Lyon — score de santé estimé</p>
        </div>
        <label>
          Risque
          <select value={riskFilter} onChange={(e) => setRiskFilter(e.target.value)}>
            <option value="">Tous</option>
            <option value="critical">À risque</option>
            <option value="watch">À surveiller</option>
            <option value="healthy">Saine</option>
          </select>
        </label>
      </header>

      {isLoading && <p className="app-status">Chargement des copropriétés…</p>}
      {error && <p className="app-error">{(error as Error).message}</p>}

      <main className="app-main">
        <aside className="app-sidebar">
          <h2>Par score ({data.length})</h2>
          <CoproList coproprietes={data} selectedId={selectedId} onSelect={setSelectedId} />
        </aside>

        <section className="app-map-column">
          <div className="app-map">
            <CoproMap coproprietes={data} selectedId={selectedId} onSelect={setSelectedId} />
            <p className="app-map-hint">Ctrl + molette pour zoomer sur la carte</p>
          </div>
          <section className="app-map-detail">
            {selected ? (
              <CoproDetail copropriete={selected} />
            ) : (
              <div className="copro-detail empty">
                Cliquez sur une copropriété dans la liste ou sur la carte.
              </div>
            )}
          </section>
        </section>
      </main>
    </div>
  )
}

export default App
