
const mongoose = require("mongoose");

// Define the RatingAndReview schema
const RatingAndReviewStorageSchema = new mongoose.Schema({
	user: {
		type: mongoose.Schema.Types.ObjectId,
		required: true,
		ref: "Farmer",
	},
	storage: {
		type: mongoose.Schema.Types.ObjectId,
		required: true,
		ref: "Storage",
		index: true,
	},
	rating: {
		type: Number,
		required: true,
	},
	review: {
		type: String,
		required: true,
	},

});

// Export the RatingAndReview model
module.exports = mongoose.model("RatingAndReviewStorage", RatingAndReviewStorageSchema);
