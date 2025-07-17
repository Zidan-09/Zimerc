import { Router } from "express";
import { RegisterMiddleware } from "../middleware/registerMiddleware";
import { ValidateCPFMiddleware } from "../middleware/validateCpfMiddleware";
import { ValidateEmailMiddleware } from "../middleware/validateEmailMiddleware";
import { UserController } from "../controllers/userController";

const userRouter: Router = Router();

userRouter.post('/register', RegisterMiddleware, ValidateCPFMiddleware, ValidateEmailMiddleware, UserController.register);
userRouter.post('/login', ValidateEmailMiddleware, UserController.login);

export default userRouter;