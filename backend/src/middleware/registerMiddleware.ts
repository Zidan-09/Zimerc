import { Request, Response, NextFunction } from "express";
import { RegisterValidators } from "../utils/server/validators";
import { HandleResponse } from "../utils/server/handleResponse";
import { UserResponses } from "../utils/enuns/serverResponses";
import { RegisterData } from "../models/register";

export async function RegisterMiddleware(req: Request<{}, {}, RegisterData>, res: Response, next: NextFunction) {
    try {
        const { user } = req.body;
        const result = await RegisterValidators.registerValidator(user);

        if (!result) {
            return HandleResponse.response(400, UserResponses.UserAlreadyExists, null, res);
        }

        next();
    
    } catch (err) {
        console.error(err);
        HandleResponse.error(res);
    }
}