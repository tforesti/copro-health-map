import { MapContainer, TileLayer, CircleMarker, useMap } from 'react-leaflet'
import { useEffect, useMemo, useRef } from 'react'
import type { Copropriete } from '../types/copropriete'
import { RISK_COLORS } from '../types/copropriete'

interface CoproMapProps {
  coproprietes: Copropriete[]
  selectedId: number | null
  onSelect: (id: number) => void
}

function CtrlScrollWheelZoom() {
  const map = useMap()

  useEffect(() => {
    map.scrollWheelZoom.disable()

    const container = map.getContainer()

    const onWheel = (event: WheelEvent) => {
      if (event.ctrlKey) {
        event.preventDefault()
        const delta = -Math.sign(event.deltaY)
        if (delta === 0) return

        map.setZoom(map.getZoom() + delta)
        return
      }

      const column = container.closest('.app-map-column')
      if (column instanceof HTMLElement) {
        column.scrollTop += event.deltaY
      }
    }

    container.addEventListener('wheel', onWheel, { passive: false })

    return () => {
      container.removeEventListener('wheel', onWheel)
    }
  }, [map])

  return null
}

function FitBounds({ coproprietes }: { coproprietes: Copropriete[] }) {
  const map = useMap()
  const lastFittedKey = useRef('')

  const datasetKey = useMemo(
    () => coproprietes.map((c) => c.id).join(','),
    [coproprietes],
  )

  useEffect(() => {
    if (!datasetKey || lastFittedKey.current === datasetKey) return

    const points = coproprietes
      .filter((c) => c.latitude && c.longitude)
      .map((c) => [Number(c.latitude), Number(c.longitude)] as [number, number])

    if (points.length === 0) return

    lastFittedKey.current = datasetKey
    map.fitBounds(points, { padding: [40, 40] })
  }, [datasetKey, map])

  return null
}

export function CoproMap({ coproprietes, selectedId, onSelect }: CoproMapProps) {
  const mappable = useMemo(
    () => coproprietes.filter((c) => c.latitude && c.longitude),
    [coproprietes],
  )

  return (
    <MapContainer center={[45.764, 4.8357]} zoom={12} className="copro-map" scrollWheelZoom={false}>
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="https://carto.com/attributions">CARTO</a>'
        url="https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png"
      />
      <CtrlScrollWheelZoom />
      <FitBounds coproprietes={mappable} />
      {mappable.map((copro) => {
        const isSelected = copro.id === selectedId
        const color = copro.risk_level ? RISK_COLORS[copro.risk_level] : '#94a3b8'

        return (
          <CircleMarker
            key={copro.id}
            center={[Number(copro.latitude), Number(copro.longitude)]}
            radius={isSelected ? 14 : 10}
            pathOptions={{
              color: isSelected ? '#1e293b' : color,
              fillColor: color,
              fillOpacity: 0.85,
              weight: isSelected ? 3 : 2,
            }}
            eventHandlers={{
              click: () => onSelect(copro.id),
            }}
          />
        )
      })}
    </MapContainer>
  )
}
