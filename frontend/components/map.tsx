// Next.js essaie de rendre les pages côté serveur par défaut, et vue que Leaflet utilise des objets pas disponibles côté serveur,
// on doit indiquer à Next.js de ne pas rendre ce composant côté serveur,
// Cela garantit que le composant Map ne sera rendu que côté client.

'use client';
import { MapContainer, TileLayer, Marker, Popup, GeoJSON } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import { useState, useEffect } from 'react';

export default function Map() {
  const [parcelles, setParcelles] = useState(null);

  useEffect(() => {
    fetch('http://localhost:3001/api/parcelles')
      .then(res => res.json())
      .then(data => setParcelles(data));
  }, []);

  return (
    <MapContainer center={[49.5, 3.5]} zoom={10} style={{ height: '100vh', width: '100%' }}>
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      {parcelles && <GeoJSON key={JSON.stringify(parcelles).length} data={parcelles} />}
    </MapContainer>
  );
}