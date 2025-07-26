import { Request, Response, NextFunction } from "express";
import { HandleResponse } from "../utils/server/handleResponse";
import { UserResponses } from "../utils/enuns/serverResponses";
import { validateEmail } from "../utils/server/validators";

export function ValidateEmailMiddleware(req: Request, res: Response, next: NextFunction) {
    try {
        const email: string = req.body.email || req.body.user?.email;

        if (!email || !validateEmail(email.trim())) {
            return HandleResponse.response(400, UserResponses.InvalidEmail, null, res);
        }

        next();

    } catch (err) {
        console.error(err);
        HandleResponse.error(res);
    }
}