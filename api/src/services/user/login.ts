import { Login } from "../../models/user";
import { db } from "../../database/mysql";
import { RowDataPacket } from "mysql2";
import { UserResponses } from "../../utils/enuns/serverResponses";
import { Security } from "../../utils/server/security";

export async function LoginUser(data: Login): Promise<string|UserResponses|undefined> {
    try {
        const [userdata] = await db.execute<RowDataPacket[]>('SELECT * FROM user WHERE email = ?', [data.email]);

        if (userdata.length == 0) {
            return UserResponses.InvalidEmail;
        }

        const result = await Security.compare(data.password, userdata[0].password);

        if (result) {
            const token = Security.signLogin(userdata[0].user_id, userdata[0].user_type);
            return token;
        }

        return UserResponses.InvalidPassword;

    } catch (err) {
        console.error(err);
        return undefined;
    }
}