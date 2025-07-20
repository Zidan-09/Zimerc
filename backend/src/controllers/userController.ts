import { Request, Response } from 'express';
import { Login } from '../models/user';
import { LoginUser } from '../services/user/login';
import { HandleResponse } from '../utils/server/handleResponse';
import { RegisterUser } from '../services/user/registerUser';
import { UserResponses } from '../utils/enuns/serverResponses';
import { UserType } from '../utils/enuns/userTypes';
import { RegisterCompany } from '../services/company/registerCompany';
import { RegisterData } from '../models/register';

export const UserController = {
    async register(req: Request<{}, {}, RegisterData>, res: Response) {
        try {
            const { user, company } = req.body;

            let created = false;

            const userCreated = await RegisterUser(user);

            if (userCreated) {
                if (user.user_type === UserType.OWNER) {
                    const companyCreated = await RegisterCompany(company);
                    created = !!companyCreated;
                } else {
                    created = true;
                }
            }

        const statusCode = created ? 201 : 400;
        const responseCode = created ? UserResponses.UserCreated : UserResponses.UserCreationFailed;

        return HandleResponse.response(statusCode, responseCode, null, res);

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
            } else {
                HandleResponse.response(400, UserResponses.InvalidPassword, null, res);
            }

        } catch (err) {
            console.error(err);
            HandleResponse.error(res);
        }
    }
};