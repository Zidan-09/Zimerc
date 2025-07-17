import { Register } from "../../models/user";
import { db } from "../../database/mysql";
import { ResultSetHeader } from 'mysql2';
import bcrypt from 'bcryptjs';

export async function RegisterUser(data: Register) {
    const sql: string = 'INSERT INTO user (name, cpf, email, password, user_type, company_id) VALUES (?, ?, ?, ?, ?, ?)';

    try {
        const password = await bcrypt.hash(data.password, 10);
        const companyId = data.company_id ?? null;

        const [result] = await db.execute<ResultSetHeader>(sql, [data.name, data.cpf, data.email, password, data.user_type, companyId]);
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