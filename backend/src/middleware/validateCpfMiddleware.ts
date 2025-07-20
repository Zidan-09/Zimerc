import { Request, Response, NextFunction } from 'express';
import { RegisterValidators } from "../utils/server/validators";
import { UserResponses } from '../utils/enuns/serverResponses';
import { HandleResponse } from '../utils/server/handleResponse';
import { RegisterData } from '../models/register';

export async function ValidateCPFMiddleware(req: Request<{}, {}, RegisterData>, res: Response, next: NextFunction) {
    try {
        const { user } = req.body;
        const result = await RegisterValidators.validateCpf(user.cpf);

        if (!result) {
            return HandleResponse.response(400, UserResponses.CPFInvalid, null, res);
        }

        next();

    } catch (err) {
        console.error(err);
        HandleResponse.error(res);
    }
};