import { Request, Response, NextFunction } from "express";
import { HandleResponse } from "../utils/server/handleResponse";
import { UserResponses } from "../utils/enuns/serverResponses";
import { validateEmail } from "../utils/server/validators";

export function ValidateEmail(req: Request, res: Response, next: NextFunction) {
    try {
        const data = req.body;
        const result = validateEmail(data.email);

        if (!result) {
            return HandleResponse.response(400, UserResponses.InvalidEmail, null, res);
        }

        next();

    } catch (err) {
        console.error(err);
        HandleResponse.error(res);
    }
}