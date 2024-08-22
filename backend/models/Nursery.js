const mongoose = require('mongoose');

const nurserySchema = new mongoose.Schema({
    // Define the owner's name field with type String, required, and trimmed
    nursery_owner: {
        type: String,
        required: true,
        trim: true,
    },
    // Define the nursery name field with type String, required, and trimmed
    nursery_name: {
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
    // Define the nursery contact field with type String, required, and trimmed
    nursery_contact: {
        type: String,
        required: true,
        trim: true,
    },
    // Define the nurseryStock field with type array of embedded document references
    nurseryStock: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: "NurseryStock",
    }],
    // Define the ratingAndReview field with type array of embedded document references
    ratingAndReview: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: "RatingAndReviewNursery",
    }],
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User', // Assuming 'User' is the name of the referenced model
  },
    // Define the certificate field with type reference to Certificate model
    certificate: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Certificate",
    }
});

module.exports = mongoose.model("Nursery", nurserySchema);