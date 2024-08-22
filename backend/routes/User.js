// Import the required modules
const express = require("express")
const router = express.Router()

// Import the required controllers and middleware functions
const {
  login,
  signup,
  sendotp,
  changePassword,
} = require("../controllers/Auth")
const {
  resetPasswordToken,
  resetPassword,
} = require("../controllers/ResetPassword")
const { farmerInfo, fetchFarmerCoordinatesByUserId } = require("../controllers/FarmerInfo"); // Import the farmerInfo controller
const { createNursery,getNurseryInfoByName,getallNursery,nearNurseries } = require("../controllers/NurseryInfo"); // Import the farmerInfo controller
const {storageInfo,getallStorage, nearStorages } = require("../controllers/StorageInfo"); // Import the farmerInfo controller
const {
  createNurseryStock,getAllNurseryStocks,updateNurseryStock,deleteNurseryStock,getNurseryInfoByUserId
} = require('../controllers/NurseryStock');
const{getStorageInfoByUserId,getStorageInfoByName,fetchStorageAndRent,rentStorageStock,createStorageStockUser,updateStorageStockUser,deleteStorageStockUser,getAllStorageStockUsers}=require('../controllers/StorageStockUser');
const { auth } = require("../middlewares/auth")

// Routes for Login, Signup, and Authentication

// ********************************************************************************************************
//                                      Authentication routes
// ********************************************************************************************************

// Route for user login
router.post("/login", login)

// Route for user signup
router.post("/signup", signup)

// Route for sending OTP to the user's email
router.post("/sendotp", sendotp)

// Route for Changing the password
router.post("/changepassword", auth, changePassword)

// ********************************************************************************************************
//                                      Reset Password
// ********************************************************************************************************

// Route for generating a reset password token
router.post("/reset-password-token", resetPasswordToken)

// Route for resetting user's password after verification
router.post("/reset-password", resetPassword)
// Route for saving farmer information
router.post("/farmerInfo", auth,farmerInfo);
router.post("/storageInfo", auth, storageInfo);
router.post("/nurseryInfo", auth, createNursery);



router.get('/storagebyName/info', auth, getStorageInfoByName);
router.get('/storage/infostock', auth, fetchStorageAndRent);
// Route for renting storage stock
// Define route for renting storage stock
router.get('/storage/:storageId/rent', auth, rentStorageStock);
router.post('/storage/:storageId/rent', auth, rentStorageStock);
router.get('/nursery/info',  getNurseryInfoByName);
router.get('/storage/info', getStorageInfoByName);

router.get('/allNurseries',getallNursery);
router.get('/allStorages',getallStorage);
router.get('/nearNurseries',nearNurseries);
router.get('/nearStorages',nearStorages);
router.get('/fetchcoordfarmer',fetchFarmerCoordinatesByUserId);
router.get('/getstoragebyid',getStorageInfoByUserId);
router.get('/getnurserybyid',getNurseryInfoByUserId);

// Create a storage stock user
router.post('/createstockuser', createStorageStockUser);

// Read all storage stock users
router.get('/getallstockuser/:id', getAllStorageStockUsers);

// Update a storage stock user
router.put('/updatestockuser/:id',updateStorageStockUser);

// Delete a storage stock user
router.delete('/deletestockuser/:id',deleteStorageStockUser);
// Create a storage stock user

router.post('/createnurserystock', createNurseryStock);

// Read all storage stock users
router.get('/getallnurserystock/:id', getAllNurseryStocks);

// Update a storage stock user
router.put('/updatenurserystock/:id',updateNurseryStock);

// Delete a storage stock user
router.delete('/deletenurserystock/:id',deleteNurseryStock);

module.exports=router;
