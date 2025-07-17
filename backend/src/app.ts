import express, { Application } from 'express';
import userRouter from './routes/user.routes';
import cors from 'cors';

const app: Application = express();

app.use(cors());
app.use(express.json());

app.use('/user', userRouter);

export default app;