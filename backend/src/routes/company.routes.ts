import { Router } from "express";
import { CompanyController } from "../controllers/companyController";

const companyRouter: Router = Router();

companyRouter.get('/getLink', CompanyController.createLink);

export default companyRouter;