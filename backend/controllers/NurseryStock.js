const NurseryStock = require('../models/NurseryStock');
const Nursery = require('../models/Nursery');

// Create a nursery stock
exports.getNurseryInfoByUserId = async (req, res) => {
    try {
        const userId = req.query.userId; // Get the user ID from the query parameters

        // Fetch storage information based on the user ID and populate the 'user' field
        const userNursery = await Nursery.find({ user: userId }).populate('nurseryStock');
        // Check if there are any storage entries for the user
        if (userNursery.length === 0) {
            return res.status(404).send({ error: 'No nursery found for this user!' });
        }

        // Send storage information for the user as response
        res.status(200).send(userNursery);
    } catch (error) {
        // Handle error
        console.error(error); // Log the error to the console
        res.status(500).send({ error: 'Internal server error!' });
    }
};
exports.createNurseryStock = async (req, res) => {
    try {
        const { nursery, varieties, quantity, price } = req.body;

        // Create a new nursery stock instance
        const newNurseryStock = new NurseryStock({
            nursery,
            varieties,
            quantity,
            price
        });

        // Save the new nursery stock
        const savedNurseryStock = await newNurseryStock.save();

        // Find the nursery by ID and update its nurseryStock field
        const updatedNursery = await Nursery.findByIdAndUpdate(
            nursery,
            { $push: { nurseryStock: savedNurseryStock._id } }, // Add the reference to the new nursery stock
            { new: true } // Return the updated nursery document
        );

        return res.status(201).json({
            success: true,
            message: 'Nursery stock created successfully',
            nurseryStock: savedNurseryStock,
            updatedNursery: updatedNursery // Optional: Return the updated nursery document
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({
            success: false,
            message: 'Failed to create nursery stock',
            error: err.message
        });
    }
};

// Read all nursery stocks
exports.getAllNurseryStocks = async (req, res) => {
    try {
        const nurseryId=req.params.id;
        const nurseryStock = await NurseryStock.find({nursery:nurseryId});

        return res.status(200).json({
            success: true,
            message: 'Fetched nursery stocks successfully',
            nurseryStock: nurseryStock
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({
            success: false,
            message: 'Failed to fetch nursery stocks',
            error: err.message
        });
    }
};

// Update a nursery stock
exports.updateNurseryStock = async (req, res) => {
    try {
        const nurseryStockId = req.params.id;
        const { varieties, quantity, price } = req.body;

        const updatedNurseryStock = await NurseryStock.findByIdAndUpdate(
            nurseryStockId,
            { varieties, quantity, price },
            { new: true }
        );

        return res.status(200).json({
            success: true,
            message: 'Nursery stock updated successfully',
            nurseryStock: updatedNurseryStock
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({
            success: false,
            message: 'Failed to update nursery stock',
            error: err.message
        });
    }
};

// Delete a nursery stock
exports.deleteNurseryStock = async (req, res) => {
    try {
        const nurseryStockId = req.params.id;

        await NurseryStock.findByIdAndDelete(nurseryStockId);

        return res.status(200).json({
            success: true,
            message: 'Nursery stock deleted successfully'
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({
            success: false,
            message: 'Failed to delete nursery stock',
            error: err.message
        });
    }
};

