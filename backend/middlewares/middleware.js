const winston = require('winston');

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

module.exports = { logErrors };
