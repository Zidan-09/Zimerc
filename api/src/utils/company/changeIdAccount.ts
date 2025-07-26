import { ResultSetHeader } from "mysql2";
import { PoolConnection } from "mysql2/promise";

export async function changeIdAccount(company: number, user: number, connection: PoolConnection): Promise<boolean> {
    try {
        const sql: string = 'UPDATE user SET company_id = ? WHERE user_id = ?';
    
        const [result] = await connection.execute<ResultSetHeader>(sql, [company, user]);
    
        if (result.affectedRows > 0) {
            return true;
        }
    
        return false;

    } catch (err) {
        console.error(err);
        return false;
    }
}