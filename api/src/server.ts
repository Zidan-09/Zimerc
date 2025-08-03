import app from './app';
import { createServer } from 'http';
require('dotenv').config();

const HOST = '0.0.0.0'
const PORT = parseInt(process.env.PORT!);

async function start() {
    const server = createServer(app);
    
    server.listen(PORT, HOST, () => {
        console.log(`Server open on: http://${HOST}:${PORT}`);
    })
}

start();