import { Company } from "../../models/company";
import { db } from "../../database/mysql";
import { ResultSetHeader } from "mysql2";

export async function RegisterCompany(data: Company) {
    const sql: string = 'INSERT INTO company (name, cnpj, contact, country, state, city, street, number) VALUES (?, ?, ?, ?, ?, ?, ?, ?)';

    try {
        const [result] = await db.execute<ResultSetHeader>(sql, [data.name, data.cnpj, data.contact, data.country, data.state, data.city, data.street, data.number]);
        const id = result.insertId;

        if (id) {
            return true;
        }

        return false;

    } catch (err) {
        console.error(err);
        return false;
    }
}