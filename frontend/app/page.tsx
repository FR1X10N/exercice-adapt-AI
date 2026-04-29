// Page principale de l'application Next.js.
// La carte Leaflet est chargée dynamiquement

'use client';
import dynamic from 'next/dynamic';

const Map = dynamic(() => import('../components/map'), { ssr: false });

export default function Home() {
  return <Map />;
}
