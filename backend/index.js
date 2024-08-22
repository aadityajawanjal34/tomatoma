const express = require('express');
const winston = require('winston');
// Create Express app
const app = express();

// Logger configuration
const logger = winston.createLogger({
  level: 'error',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    // Add other transports as needed (e.g., console)
  ],
});

// Middleware function for logging errors
function logErrors(err, req, res, next) {
  logger.error({
    message: 'Authentication error',
    error: err.message,
    stack: err.stack,
    request: {
      method: req.method,
      url: req.url,
      headers: req.headers,
      body: req.body,
    },
  });
  next(err);
}

// Apply middleware
app.use(logErrors);


const userRoutes=require('./routes/User');


const certificateRoutes=require('./routes/certificate');
const database=require('./config/database');
const cookieParser=require('cookie-parser');

const cors=require('cors');
const {cloudinaryConnect}=require('./config/cloudinary');
const fileUpload=require('express-fileupload');

const dotenv=require("dotenv");
dotenv.config()
const PORT=process.env.PORT || 4000

//database connect
database.connect()
//middlewares

app.use(express.json());
app.use(cookieParser());


app.use(
    cors({
        origin:'*',
        credentials:true,
    })
)

app.use(
    fileUpload({
        useTempFiles:true,
        tempFileDir:"/tmp",
    })
)

//cloudinary connection
cloudinaryConnect();

//routes
app.use('/api/v1/auth',userRoutes);
app.use('/api/v1/certificate',certificateRoutes);

//default route
app.get("/",(req,res)=>{
    return res.json({
        success:true,
        message:'Your server is up and running.....'
    })
})

app.listen(PORT,()=>{
    console.log(`App is running at ${PORT}`)
})