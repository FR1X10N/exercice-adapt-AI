const express = require('express');
const router = express.Router();
const pool = require('../db');

// GET /api/parcelles
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT idu, section, nom_com, ST_AsGeoJSON(wkb_geometry) as geom FROM parcelles LIMIT 1000');
    const features = result.rows.map(row => ({
      type: 'Feature',
      geometry: JSON.parse(row.geom),
      properties: {
        idu: row.idu,
        section: row.section,
        nom_com: row.nom_com
      }
    }));
    res.json({
      type: 'FeatureCollection',
      features
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/parcelles/:idu
router.get('/:idu', async (req, res) => {
  try {
    const { idu } = req.params;
    const result = await pool.query(
      'SELECT idu, section, nom_com, ST_AsGeoJSON(wkb_geometry) as geom FROM parcelles WHERE idu = $1',
      [idu]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Parcelle non trouvée' });
    }
    const row = result.rows[0];
    const feature = {
      type: 'Feature',
      geometry: JSON.parse(row.geom),
      properties: {
        idu: row.idu,
        section: row.section,
        nom_com: row.nom_com
      }
    };
    res.json(feature);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;