import { Request, Response } from "express";
import { HandleResponse } from "../utils/server/handleResponse";
import { GenerateLink } from "../services/company/generateLink";
import { CompanyResponses } from "../utils/enuns/serverResponses";

export const CompanyController = {
    async createLink(req: Request, res: Response) {
        try {
            const { authorization } = req.headers;

            const link = await GenerateLink(authorization!.split(' ')[1]);

            HandleResponse.response(200, CompanyResponses.LinkGenerated, link, res);
                       
        } catch (err) {
            console.error(err);
            HandleResponse.error(res);
        }
    }
}