import { Company } from "../../models/company";
import { ResultSetHeader } from "mysql2";
import { PoolConnection } from "mysql2/promise";

export async function RegisterCompany(data: Company, connection: PoolConnection): Promise<number|undefined> {
    const sql: string = 'INSERT INTO company (name, cnpj, contact, country, state, city, street, number) VALUES (?, ?, ?, ?, ?, ?, ?, ?)';

    try {
        const [result] = await connection.execute<ResultSetHeader>(sql, [data.name, data.cnpj, data.contact, data.country, data.state, data.city, data.street, data.number]);
        const id = result.insertId;

        return id || undefined;

    } catch (err) {
        console.error(err);
        return undefined;
    }
}