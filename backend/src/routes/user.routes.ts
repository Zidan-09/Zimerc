import { Router } from "express";
import { RegisterMiddleware } from "../middleware/registerMiddleware";
import { UserController } from "../controllers/userController";

const userRouter: Router = Router();

userRouter.post('/register', RegisterMiddleware, UserController.register);

export default userRouter;