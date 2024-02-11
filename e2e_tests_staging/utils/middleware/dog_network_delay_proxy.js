const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();

const PORT = 8201; // Port for the proxy server
const DELAY_MS = 1000; // Delay in milliseconds
const TEST_WEB_SERVER_PORT = process.env.TEST_WEB_SERVER_PORT;

if (!TEST_WEB_SERVER_PORT) {
    console.error('Error: No target server port provided.');
    process.exit(1);
}

const TARGET_SERVER = 'http://localhost:' + TEST_WEB_SERVER_PORT;

app.use(cors({
    exposedHeaders: ['X-Custom-Signature-Header'],
}));

// Middleware to introduce delay
const delayMiddleware = (req, res, next) => {
    setTimeout(next, DELAY_MS);
};

// Function to forward requests to the target server
async function forwardRequest(req, res) {
    try {
        const url = TARGET_SERVER + req.originalUrl;
        const method = req.method;

        // Forwarding the headers and body to the actual server
        const response = await axios({
            method: method,
            url: url,
            headers: req.headers,
            data: req.body
        });

		for (key in response.headers) {
			res.setHeader(key, response.headers[key]);
		}

        // Sending back the response from the actual server to the client
        res.status(response.status).send(response.data);
    } catch (error) {
        res.status(500).send(error.toString());
    }
}

// Route handler for '/renderBreeds' with delay
app.get('/renderBreeds', delayMiddleware, (req, res) => {
    forwardRequest(req, res);
});

// Proxy request handler
app.use((req, res) => {
    forwardRequest(req, res);
});

app.listen(PORT, () => {
    console.log(`Proxy server running on http://localhost:${PORT}`);
});