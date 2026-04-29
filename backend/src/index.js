// fichier principal du backend.
// cree les routes de l'API
// et démarre le serveur sur le port défini dans les variables d'environnement.
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

app.use(express.json());
app.use(cors());

app.use('/api/parcelles', require('./routes/parcelles'));
app.use('/api/siren', require('./routes/siren'));

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
