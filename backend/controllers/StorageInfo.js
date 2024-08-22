const Storage = require('../models/Storage');

exports.storageInfo = async (req, res) => {
    try {
        const {
            storage_name,
            owner_name,
            address,
            storage_contact,
            capacity,
            rate
        } = req.body;

        if (!storage_name || !owner_name || !address || !storage_contact || !capacity || !rate) {
            return res.status(403).send({
                success: false,
                message: "All Fields are required",
            });
        }
        const userId = req.user.id;

        // Assuming the address object contains `type` and `coordinates` fields
        const storage = await Storage.create({
            storage_name,
            owner_name,
            address,
            storage_contact,
            user: userId,
            ratingAndReview: null, // Set initial value to null
            capacity,
            rate,
            // certificate: certificate._id,
        });

        // Return response
        return res.status(200).json({
            success: true,
            message: "Storage information saved successfully",
            storage,
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({
            success: false,
            message: "Failed to create storage",
            error: err.message,
        });
    }
};

exports.getallStorage = async (req, res) => {
    try {
        
        // Fetch Storage information by name
        const allStorageInfo = await Storage.find();
        console.log(allStorageInfo)
        // Check if Storage information is found
        if (!allStorageInfo) {
            return res.status(404).send({ error: 'No Storage' });
        }

        // Send Storage information as response
        res.status(200).send(allStorageInfo);
    } catch (error) {
        // Handle error
        console.error(error); // Log the error to the console
        res.status(500).send({ error: 'Internal server error!' });
    }
};

exports.nearStorages = async (req, res) => {
    try {
        const { longitude, latitude } = req.query; // Get longitude and latitude from query parameters

        // Define the range for latitude and longitude to create a rectangular box
        const latitudeRange = [parseFloat(latitude) - 1, parseFloat(latitude) + 1]; // Adjust the range as needed
        const longitudeRange = [parseFloat(longitude) - 1, parseFloat(longitude) + 1]; // Adjust the range as needed

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

        // Query storages within the specified range of latitude and longitude
        const storages = await Storage.find(query);

        res.json({ storages });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
};
