import { RowDataPacket } from "mysql2";
import { db } from "../../database/mysql";

export async function searchCompany(userId: number): Promise<number> {
    const sql: string = 'SELECT company_id FROM user WHERE user_id = ?'
    const [[result]] = await db.execute<RowDataPacket[]>(sql, [userId]);
    return result.company_id
}