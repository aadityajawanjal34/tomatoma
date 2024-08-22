const mongoose=require('mongoose');

const nurseryStockSchema=new mongoose.Schema({
    nursery:{
        type:mongoose.Schema.Types.ObjectId,
        required:true,
        ref:"Nursery",
    },
    
    varieties:{
        type:String
    },
    quantity:{
        type:Number,
    },
    price:{
        type:Number,
    }
})


module.exports=mongoose.model("NurseryStock",nurseryStockSchema);