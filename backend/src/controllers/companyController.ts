import { Request, Response } from "express";
import { HandleResponse } from "../utils/server/handleResponse";

const CompanyController = {
    async createLink(req: Request, res: Response) {
        try {
            const a = 1;


            
        } catch (err) {
            console.error(err);
            HandleResponse.error(res);
        }
    }
}