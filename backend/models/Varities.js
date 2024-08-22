const mongoose=require('mongoose');

const varietySchema=new mongoose.Schema({
    variety_name:{
        type:String,
        required:true,
    },
})


module.exports=mongoose.model("Variety",varietySchema);