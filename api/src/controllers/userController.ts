import { Request, Response } from 'express';
import { Login } from '../models/user';
import { LoginUser } from '../services/user/login';
import { HandleResponse } from '../utils/server/handleResponse';
import { RegisterUser } from '../services/user/registerUser';
import { UserResponses } from '../utils/enuns/serverResponses';
import { UserType } from '../utils/enuns/userTypes';
import { RegisterCompany } from '../services/company/registerCompany';
import { RegisterData } from '../models/register';
import { changeIdAccount } from '../utils/company/changeIdAccount';
import { db } from '../database/mysql';

export const UserController = {
    async register(req: Request<{}, {}, RegisterData>, res: Response) {
        const connection = await db.getConnection();
        
        try {
            await connection.beginTransaction();

            const { user, company } = req.body;

            const userId = await RegisterUser(user, connection);

            if (!userId) {
                throw new Error(UserResponses.UserCreationFailed);
            }

            if (user.user_type === UserType.OWNER) {
                const companyId = await RegisterCompany(company, connection);

                if (!companyId) {
                    throw new Error(UserResponses.CompanyCreationFailed)
                }

                const updated = await changeIdAccount(companyId, userId, connection)
                
                if (!updated) {
                    throw new Error(UserResponses.LinkUserToCompanyFailed)
                }
                
            }

            await connection.commit();
            return HandleResponse.response(201, UserResponses.UserCreated, null, res);

        } catch (err) {
            console.error(err);
            connection.rollback();
            HandleResponse.error(res);

        } finally {
            connection.release();
        }
    },

    async login(req: Request<{}, {}, Login>, res: Response) {
        try {
            const data = req.body;
            const token = await LoginUser(data);

            if (token) {
                HandleResponse.response(200, UserResponses.UserLoggedIn, token, res);
            } else {
                HandleResponse.response(400, UserResponses.InvalidPassword, null, res);
            }

        } catch (err) {
            console.error(err);
            HandleResponse.error(res);
        }
    }
};