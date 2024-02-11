const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();

// Enable CORS for all routes
app.use(cors());

// Serve static files from a specific directory
app.use('/', express.static(path.join(__dirname, '../static_web_test')));

// Use environment variable or default to 7654
const PORT = process.env.STATIC_WEB_TEST_SERVER_PORT ? parseInt(process.env.STATIC_WEB_TEST_SERVER_PORT, 10) : 7654;

// Check if port is a valid number
if (isNaN(PORT) || PORT <= 0 || PORT > 65535) {
    console.error(`Error: Invalid port number ${PORT}`);
    process.exit(1);
}

// Check if the port is already in use
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
}).on('error', (error) => {
    if (error.code === 'EADDRINUSE') {
        console.error(`Error: Port ${PORT} is already in use`);
        process.exit(1);
    } else {
        throw error; // For other types of errors, propagate the exception
    }
});


//Code powered by OpenAI, ChatGPT-4.