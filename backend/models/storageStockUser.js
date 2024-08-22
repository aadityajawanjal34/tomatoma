const mongoose=require('mongoose');

const storageStockUserSchema=new mongoose.Schema({
    storage:{
        type:mongoose.Schema.Types.ObjectId,
        ref:"Storage",
    },
    farmer:{
        type:String,
        required:true,
    },
    period:{
        type:Number,
        required:true,
    },
    capacity:{  
        type:Number,
        required:true,
    }
})

module.exports=mongoose.model("storageStockUser",storageStockUserSchema);