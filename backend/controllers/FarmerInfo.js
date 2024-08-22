const Farmer = require('../models/Farmer');

exports.farmerInfo = async (req, res) => {
    try {
        const { farmer_name, address, farmer_contact } = req.body;

        if (!farmer_name || !address || !farmer_contact) {
            return res.status(400).json({
                success: false,
                message: 'All fields are required',
            });
        }
        const userId = req.user.id;
        const farmer = await Farmer.create({
            farmer_name,
            address,
            farmer_contact,
            user: userId,
        });
        console.log(farmer);
        return res.status(200).json({
            success: true,
            message: 'Farmer information saved successfully',
            farmer,
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({
            success: false,
            message: 'An error occurred while saving farmer information.',
            error: error.message,
        });
    }
};

// Controller function to fetch farmer longitude and latitude based on user ID
exports.fetchFarmerCoordinatesByUserId = async (req, res) => {
    try {
        const userId = req.query.userId;
        console.log('Received userId:', userId); // Log the received userId

        // Query the Farmer collection based on the userId
        const farmer = await Farmer.findOne({ user: userId });

        if (!farmer) {
            console.log('Farmer not found for the given user ID');
            return res.status(404).json({ message: 'Farmer not found for the given user ID' });
        }

        console.log('Found farmer:', farmer); // Log the found farmer document
        // Extract the coordinates from the farmer document and send them in the response
        const { coordinates } = farmer.address;
        res.json({ coordinates });
    } catch (error) {
        console.error('Error fetching farmer:', error); // Log any errors that occur
        res.status(500).json({ message: 'Internal server error' });
    }
};
