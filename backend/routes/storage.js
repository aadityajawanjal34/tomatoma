const express = require('express');
const router = express.Router();
const { StorageInfo } = require('../controllers/StorageInfo');

// POST request to save storage information
router.post('/storage', StorageInfo);

module.exports = router;
