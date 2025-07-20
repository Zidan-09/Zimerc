import { User } from "../../models/user";
import { db } from "../../database/mysql";
import { ResultSetHeader } from 'mysql2';
import { Security } from "../../utils/server/security";

export async function RegisterUser(data: User) {
    const sql: string = 'INSERT INTO user (name, cpf, dob, email, password, user_type, company_id) VALUES (?, ?, ?, ?, ?, ?, ?)';

    try {
        const password = await Security.hash(data.password);
        const companyId = data.company_id ?? null;

        const [result] = await db.execute<ResultSetHeader>(sql, [data.name, data.cpf, data.dob, data.email, password, data.user_type, companyId]);
        const id: number = result.insertId;

        if (id) {
            return true;
        }

        return false;

    } catch (err) {
        console.error(err);
        return false;
    }
}