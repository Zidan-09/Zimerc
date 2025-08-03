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
import { Security } from '../utils/server/security';

export const UserController = {
    async register(req: Request<{}, {}, RegisterData>, res: Response) {
        const connection = await db.getConnection();
        
        try {
            await connection.beginTransaction();

            const { user, company } = req.body;

            const result = await RegisterUser(user, connection);

            if (!result?.userId) {
                throw new Error(UserResponses.UserCreationFailed);
            }

            if (user.user_type === UserType.OWNER) {
                const companyId = await RegisterCompany(company, connection);

                if (!companyId) {
                    throw new Error(UserResponses.CompanyCreationFailed)
                }

                const updated = await changeIdAccount(companyId, result.userId, connection)
                
                if (!updated) {
                    throw new Error(UserResponses.LinkUserToCompanyFailed)
                }
                
            }

            await connection.commit();
            
            const token = Security.signLogin(result.userId, result.user_type);

            return HandleResponse.response(201, UserResponses.UserCreated, token, res);

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
            const result = await LoginUser(data);

            if (result == UserResponses.InvalidEmail) {
                return HandleResponse.response(400, UserResponses.InvalidEmail, null, res);

            } else if (result == UserResponses.InvalidPassword) {
                return HandleResponse.response(400, UserResponses.InvalidPassword, null, res);
            }

            return HandleResponse.response(200, UserResponses.UserLoggedIn, result, res);

        } catch (err) {
            console.error(err);
            HandleResponse.error(res);
        }
    }
};