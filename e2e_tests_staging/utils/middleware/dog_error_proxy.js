const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();

const PORT = 8301; // Port for the proxy server
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

// Proxy request handler for '/renderBreeds' to simulate error
app.get('/renderBreeds', async (req, res) => {
    try {
        // Introduce an error condition here
        // For example, you can return an error response directly
        res.status(500).json({"error": "Simulated error from proxy"});
    } catch (error) {
        res.status(500).send(error.toString());
    }
});

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

// Proxy request handler for all other routes
app.use((req, res) => {
    forwardRequest(req, res);
});

app.listen(PORT, () => {
    console.log(`Error Proxy server running on http://localhost:${PORT}`);
});
