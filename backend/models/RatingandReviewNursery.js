const mongoose = require("mongoose");

// Define the RatingAndReview schema
const ratingAndReviewNurserySchema = new mongoose.Schema({
	user: {
		type: mongoose.Schema.Types.ObjectId,
		required: true,
		ref: "Farmer",
	},
	nursery: {
		type: mongoose.Schema.Types.ObjectId,
		required: true,
		ref: "Nursery",
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
module.exports = mongoose.model("RatingAndReviewNursery", ratingAndReviewNurserySchema);
