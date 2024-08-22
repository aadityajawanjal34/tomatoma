const mongoose = require('mongoose');

const storageSchema = new mongoose.Schema({
    // Define the storage name field with type String, required, and trimmed
    storage_name: {
        type: String,
        required: true,
        trim: true,
    },
    // Define the owner's name field with type String, required, and trimmed
    owner_name: {
        type: String,
        required: true,
        trim: true,
    },
    // Define the address field with type embedded document reference
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
    // Define the storage contact field with type String, required, and trimmed
    storage_contact: {
        type: String,
        required: true,
        trim: true,
    },
    // Define the storageStock field with type array of embedded document references
    storageStock: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: "storageStock",
    }],
    // Define the ratingAndReview field with type array of embedded document references
    ratingAndReview: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: "RatingAndReviewStorage",
    }],
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User', // Assuming 'User' is the name of the referenced model
  },
    capacity:{
        type:String,
        required:true,
    },
    rate:{
        type:String,
        required:true,
    },
    // Define the certificate field with type reference to Certificate model
    certificate: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Certificate",
    }
});

module.exports = mongoose.model("Storage", storageSchema);