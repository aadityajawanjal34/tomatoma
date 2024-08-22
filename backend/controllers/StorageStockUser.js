const Storage = require('../models/Storage');
const StorageStockUser = require('../models/storageStockUser');

// Controller function to get storage information
// Controller function to fetch storage information by user ID
// Controller function to fetch storage information by user ID
exports.getStorageInfoByUserId = async (req, res) => {
    try {
        const userId = req.query.userId; // Get the user ID from the query parameters

        // Fetch storage information based on the user ID and populate the 'user' field
        const userStorage = await Storage.find({ user: userId });
        // Check if there are any storage entries for the user
        if (userStorage.length === 0) {
            return res.status(404).send({ error: 'No storage found for this user!' });
        }

        // Send storage information for the user as response
        res.status(200).send(userStorage);
    } catch (error) {
        // Handle error
        console.error(error); // Log the error to the console
        res.status(500).send({ error: 'Internal server error!' });
    }
};
// Controller function to get storage information by name
exports.getStorageInfoByName = async (req, res) => {
    try {
        const storageName = req.query.storageName; // Get the storage name from request query
        
        // Fetch storage information by name
        console.log(storageName);
        const storageInfo = await Storage.findOne({ storage_name: storageName })  .populate('storageStock')
        .populate('storage')
        .populate('ratingAndReview');

        // Check if storage information is found
        if (!storageInfo) {
            return res.status(404).send({ error: 'Storage not found!' });
        }

        // Send storage information as response
        res.status(200).send(storageInfo);
    } catch (error) {
        // Handle error
        console.error(error); // Log the error to the console
        res.status(500).send({ error: 'Internal server error!' });
    }
};

// Controller function to fetch storage information and dynamically include storage ID in URL for renting
exports.fetchStorageAndRent = async (req, res) => {
    try {
        // Fetch storage information based on some criteria (e.g., storage name)
        const storageName = req.query.storageName;
        const storage = await Storage.findOne({ storage_name: storageName });
        console.log(storageName);
        // Check if storage information is found
        if (!storage) {
            return res.status(404).send({ error: 'Storage not found!' });
        }

        // Extract storage ID from retrieved storage data
        const storageId = storage._id;
        console.log(storageId);

        // Redirect to URL for renting storage stock with dynamically included storage ID
        res.redirect(`/storage/${storageId}/rent`);
    } catch (error) {
        // Handle error
        res.status(500).send({ error: 'Internal server error!' });
    }
};

// Controller function to rent storage stock
exports.rentStorageStock = async (req, res) => {
    try {
        const storageId = req.params.storageId; // Get the storage ID from request parameters
        const farmerId = req.user.id; // Get the farmer ID from authenticated user

        // Example logic to rent storage stock:
        // Here you can perform any additional validation or business logic before renting the storage stock
        
        // Create a new instance of storage stock user with the provided data
        const rentedStorageStock = new StorageStockUser({
            storage: storageId,
            farmer: farmerId,
            period: req.body.period,
            capacity: req.body.capacity
        });

        // Save the rented storage stock
        await rentedStorageStock.save();

        // Send success response
        res.status(201).send(rentedStorageStock);
    } catch (error) {
        // Handle error
        console.error(error); // Log the error to the console
        res.status(500).send({ error: 'Internal server error!' });
    }
};


// Create a storage stock user
exports.createStorageStockUser = async (req, res) => {
    try {
        const { storage, farmer, period, capacity } = req.body;
        
        const newStorageStockUser = new StorageStockUser({
            storage,
            farmer,
            period,
            capacity
        });

        const savedStorageStockUser = await newStorageStockUser.save();

        return res.status(201).json({
            success: true,
            message: 'Storage stock user created successfully',
            storageStockUser: savedStorageStockUser
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({
            success: false,
            message: 'Failed to create storage stock user',
            error: err.message
        });
    }
};

// Read all storage stock users
exports.getAllStorageStockUsers = async (req, res) => {
    try {
        const storageId=req.params.id
        const storageStockUsers = await StorageStockUser.find({storage:storageId});

        return res.status(200).json({
            success: true,
            message: 'Fetched storage stock users successfully',
            storageStockUsers: storageStockUsers
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({
            success: false,
            message: 'Failed to fetch storage stock users',
            error: err.message
        });
    }
};

// Update a storage stock user
exports.updateStorageStockUser = async (req, res) => {
    try {
        const storageStockUserId = req.params.id;
        const { farmer, period, capacity } = req.body;

        const updatedStorageStockUser = await StorageStockUser.findByIdAndUpdate(
            storageStockUserId,
            { farmer, period, capacity },
            { new: true }
        );

        return res.status(200).json({
            success: true,
            message: 'Storage stock user updated successfully',
            storageStockUser: updatedStorageStockUser
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({
            success: false,
            message: 'Failed to update storage stock user',
            error: err.message
        });
    }
};

// Delete a storage stock user
exports.deleteStorageStockUser = async (req, res) => {
    try {
        const storageStockUserId = req.params.id;

        await StorageStockUser.findByIdAndDelete(storageStockUserId);

        return res.status(200).json({
            success: true,
            message: 'Storage stock user deleted successfully'
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({
            success: false,
            message: 'Failed to delete storage stock user',
            error: err.message
        });
    }
};


