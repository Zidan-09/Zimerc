import { Request, Response } from 'express';
import { Register, Login } from '../models/user';
import { LoginUser } from '../services/user/login';
import { HandleResponse } from '../utils/server/handleResponse';
import { RegisterUser } from '../services/user/register';
import { UserResponses } from '../utils/enuns/serverResponses';

export const UserController = {
    async register(req: Request<{}, {}, Register>, res: Response) {
        try {
            const data = req.body;

            const result = await RegisterUser(data);

            if (result) {
                HandleResponse.response(201, UserResponses.UserCreated, null, res);
            }

            HandleResponse.response(400, 'Não criou o usuário', null, res);

        } catch (err) {
            console.error(err);
            HandleResponse.error(res);
        }
    },

    async login(req: Request<{}, {}, Login>, res: Response) {
        try {
            const data = req.body;
            const result = await LoginUser(data);

            if (result) {
                HandleResponse.response(200, UserResponses.UserLoggedIn, result, res);
            }

            HandleResponse.response(400, 'Não fez login', null, res);

        } catch (err) {
            console.error(err);
            HandleResponse.error(res);
        }
    }
};