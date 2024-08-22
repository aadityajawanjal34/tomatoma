const Nursery = require('../models/Nursery');
const { createNurseryStock } = require('./NurseryStock');
exports.createNursery = async (req, res) => {
    try {
        const {
            nursery_owner,
            nursery_name,
            address,
            nursery_contact,
        } = req.body;
        const userId = req.user.id;
        const certificateId = req.user.certificate;

        if (!nursery_owner || !nursery_name || !address || !nursery_contact) {
            return res.status(403).send({
                success: false,
                message: "All Fields are required",
            });
        }

        // Assuming the address object contains `type` and `coordinates` fields
        const nursery = await Nursery.create({
            nursery_owner,
            nursery_name,
            address,
            nursery_contact,
            user: userId,
            ratingAndReview: null, 
            // certificate: certificateId,
        });
                // Create nursery stock
         await createNurseryStock(nursery._id, { nursery: nursery._id,varities:null, quantity: 0, price: 0 }, res);

        // Return response
        return res.status(200).json({
            success: true,
            message: "Nursery information and stock saved successfully",
            nursery,
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({
            success: false,
            message: "Failed to create nursery",
            error: err.message,
        });
    }
}

exports.getNurseryInfoByName = async (req, res) => {
    try {
        const nurseryName = req.query.nurseryName; // Get the nursery name from request query
        
        // Fetch nursery information by name
        const nurseryInfo = await Nursery.findOne({ nursery_name: nurseryName }).populate('nurseryStock');
        console.log(nurseryName)
        // Check if nursery information is found
        if (!nurseryInfo) {
            return res.status(404).send({ error: 'Nursery not found!' });
        }

        // Send nursery information as response
        res.status(200).send(nurseryInfo);
    } catch (error) {
        // Handle error
        console.error(error); // Log the error to the console
        res.status(500).send({ error: 'Internal server error!' });
    }
};

exports.getallNursery = async (req, res) => {
    try {
        
        // Fetch nursery information by name
        const allnurseryInfo = await Nursery.find();
        console.log(allnurseryInfo)
        // Check if nursery information is found
        if (!allnurseryInfo) {
            return res.status(404).send({ error: 'No Nurseries' });
        }

        // Send nursery information as response
        res.status(200).send(allnurseryInfo);
    } catch (error) {
        // Handle error
        console.error(error); // Log the error to the console
        res.status(500).send({ error: 'Internal server error!' });
    }
};

// Route handler for finding nurseries near a given location
// Route handler for finding nurseries near a given location
// Route handler for finding nurseries near a given location
exports.nearNurseries = async (req, res) => {
    try {
        const { longitude, latitude } = req.query; // Get longitude and latitude from query parameters

        // Define the range for latitude and longitude to create a rectangular box
        const latitudeRange = [parseFloat(latitude) - 0.5, parseFloat(latitude) + 0.5]; // Adjust the range as needed
        const longitudeRange = [parseFloat(longitude) - 0.5, parseFloat(longitude) + 0.5]; // Adjust the range as needed

        // Define the box using latitude and longitude ranges
        const box = [
            [longitudeRange[0], latitudeRange[0]], // Bottom-left corner (southwest)
            [longitudeRange[1], latitudeRange[0]], // Bottom-right corner (southeast)
            [longitudeRange[1], latitudeRange[1]], // Top-right corner (northeast)
            [longitudeRange[0], latitudeRange[1]], // Top-left corner (northwest)
            [longitudeRange[0], latitudeRange[0]]  // Closing the loop with the first vertex
        ];

        // Log the constructed box
        console.log('Box:', box);

        // Construct the query using the box
        const query = {
            "address.coordinates": {
                $geoWithin: {
                    $geometry: {
                        type: "Polygon",
                        coordinates: [box]
                    }
                }
            }
        };

        // Log the constructed query
        console.log('Query:', query);

        // Query nurseries within the specified range of latitude and longitude
        const nurseries = await Nursery.find(query).populate('nurseryStock');

        res.json({ nurseries });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
};
