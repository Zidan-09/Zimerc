import express, { Application } from 'express';
import userRouter from './routes/user.routes';
import cors from 'cors';
import companyRouter from './routes/company.routes';

const app: Application = express();

app.use(cors());
app.use(express.json());

app.use('/user', userRouter);
app.use('/company', companyRouter);

export default app;