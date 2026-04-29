// Route API pour la recherche du SIREN d'une parcelle.
// fichier MAJIC 2021.
const express = require('express');
const router = express.Router();
const pool = require('../db');

// GET /api/siren/:idu
router.get('/:idu', async (req, res) => {
  try {
    const { idu } = req.params;
    const result = await pool.query(
      `SELECT num_siren, denomination
       FROM parcelles_pm
       WHERE departement || code_commune || REPLACE(prefixe, ' ', '0') || section || lpad(num_plan, 4, '0') = $1
       LIMIT 1`,
      [idu]
    );
    if (result.rows.length === 0) {
      return res.json({ siren: null });
    }
    const { num_siren, denomination } = result.rows[0];
    res.json({ siren: num_siren, denomination });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;