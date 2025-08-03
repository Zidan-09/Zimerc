import { User } from "../../models/user";
import { ResultSetHeader, RowDataPacket } from 'mysql2';
import { Security } from "../../utils/server/security";
import { PoolConnection } from "mysql2/promise";

interface RegisterResult {
    userId: number;
    user_type: string;
}

export async function RegisterUser(data: User, connection: PoolConnection): Promise<RegisterResult | undefined> {
    const sqlRegister: string = 'INSERT INTO user (name, cpf, dob, email, password, user_type, company_id) VALUES (?, ?, ?, ?, ?, ?, ?)';
    const sqlGet: string = 'SELECT user_type FROM user WHERE user_id = ?';

    try {
        const password = await Security.hash(data.password);
        const companyId = data.company_id ?? null;

        const [result] = await connection.execute<ResultSetHeader>(sqlRegister, [data.name, data.cpf, data.dob, data.email, password, data.user_type, companyId]);
        const id: number = result.insertId;

        const [userType] = await connection.execute<RowDataPacket[]>(sqlGet, [id]);

        return {
            userId: id,
            user_type: userType[0].user_type
        };

    } catch (err) {
        console.error(err);
        return undefined;
    }
}