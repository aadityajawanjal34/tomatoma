const express = require('express');
const router = express.Router();
const { farmerInfo } = require('../controllers/FarmerInfo');

// POST request to save farmer information
router.post('/farmer', farmerInfo);

module.exports = router;
