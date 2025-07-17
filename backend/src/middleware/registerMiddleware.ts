import { Request, Response, NextFunction } from "express";
import { RegisterValidators } from "../utils/server/validators";
import { Register } from "../models/user";
import { HandleResponse } from "../utils/server/handleResponse";
import { UserResponses } from "../utils/enuns/serverResponses";

export async function RegisterMiddleware(req: Request<{}, {}, Register>, res: Response, next: NextFunction) {
    try {
        const data: Register = req.body;
        const result = await RegisterValidators.registerValidator(data);

        if (!result) {
            return HandleResponse.response(400, UserResponses.UserAlreadyExists, null, res);
        }

        next();
    
    } catch (err) {
        console.error(err);
        HandleResponse.error(res);
    }
}