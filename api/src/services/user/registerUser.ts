import { User } from "../../models/user";
import { ResultSetHeader } from 'mysql2';
import { Security } from "../../utils/server/security";
import { PoolConnection } from "mysql2/promise";

export async function RegisterUser(data: User, connection: PoolConnection): Promise<number | undefined> {
    const sql: string = 'INSERT INTO user (name, cpf, dob, email, password, user_type, company_id) VALUES (?, ?, ?, ?, ?, ?, ?)';

    try {
        const password = await Security.hash(data.password);
        const companyId = data.company_id ?? null;

        const [result] = await connection.execute<ResultSetHeader>(sql, [data.name, data.cpf, data.dob, data.email, password, data.user_type, companyId]);
        const id: number = result.insertId;

        return id || undefined;

    } catch (err) {
        console.error(err);
        return undefined;
    }
}