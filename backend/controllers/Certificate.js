const Cert=require('../models/Certificate');
const User =require('../models/User')
require("dotenv").config();
const { uploadImageToCloudinary } = require("../utils/imageUploader");
exports.getAllCertificates = async (req, res) => {

try{const userId = req.user.id;
    console.log(req.user.id);
    const userDetails = await User.findOne({ _id: userId }).populate("certificate").exec();
    console.log(userDetails);
    return res.status(200).json({ success: true, data: userDetails })
}
    catch(error){
        console.log(error);
        return res.status(401).json({
            success:false,
            message:'Trouble getting Certificates'
        })
    }
}

exports.certificateUploader=async(req,res)=>{
try{   
    const certificate=req.files.certificate;
    const userId=req.user.id;

    const userDetails=await User.findOne({_id:userId});
    console.log(userDetails);

    

    const uploadCertificate= await uploadImageToCloudinary(
        certificate,
        process.env.FOLDER_NAME
      )
      console.log(uploadCertificate)


    const certnewUpload=await Cert.create({imageUrl:uploadCertificate.secure_url},
                                         );
    console.log(certnewUpload);
    const updatedUser = await User.findByIdAndUpdate(
        { _id: req.user.id },
        { $push: { certificate:certnewUpload._id } },
        { new: true }
      ).populate("certificate")

      return res.status(200).json({ success: true, data: updatedUser })
    }
    catch(error){
        console.log(error);
        return res.status(401).json({
            success:false,
            message:'Trouble uploading Ceertificates'
        })
    }

}

