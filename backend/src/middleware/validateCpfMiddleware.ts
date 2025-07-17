import { Request, Response, NextFunction } from 'express';
import { Register } from '../models/user';
import { RegisterValidators } from "../utils/server/validators";
import { UserResponses } from '../utils/enuns/serverResponses';
import { HandleResponse } from '../utils/server/handleResponse';

export async function ValidateCPFMiddleware(req: Request<{}, {}, Register>, res: Response, next: NextFunction) {
    try {
        const data = req.body;
        const result = await RegisterValidators.validateCpf(data.cpf);

        if (!result) {
            return HandleResponse.response(400, UserResponses.CPFInvalid, null, res);
        }

        next();

    } catch (err) {
        console.error(err);
        HandleResponse.error(res);
    }
};