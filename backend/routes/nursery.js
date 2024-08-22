const express = require('express');
const router = express.Router();
const { createNursery } = require('../controllers/NurseryInfo');

// POST request to create nursery
router.post('/nursery', createNursery);

module.exports = router;
