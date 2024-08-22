const mongoose = require('mongoose');

const farmerSchema = new mongoose.Schema({   
    farmer_name: {
        type: String,
        required: true,
        trim: true,
    },
    address: {
        type: {
            type: String,
            enum: ['Point'], // Only allow 'Point' type for GeoJSON
            required: true
        },
        coordinates: {
            type: [Number],
            required: true
        },
        Sublocality:{
            type:String,
        }
    },
    
    farmer_contact: {
        type: String,
        required: true,
        trim: true,
    },
    certificate: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Certificate', // Assuming 'Certificate' is the name of the referenced model
    },
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User', // Assuming 'User' is the name of the referenced model
    }
});

module.exports = mongoose.model('Farmer', farmerSchema);
