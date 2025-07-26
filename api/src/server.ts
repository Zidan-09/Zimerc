import app from './app';
import { createServer } from 'http';
require('dotenv').config;

const PORT = process.env.PORT!;

async function start() {
    const server = createServer(app);
    
    server.listen(PORT, () => {
        console.log(`Server open on: http://localhost:${PORT}`);
    })
}

start();