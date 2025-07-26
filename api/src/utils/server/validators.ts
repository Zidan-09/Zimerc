import { User } from "../../models/user";
import { db } from "../../database/mysql";
import { RowDataPacket } from 'mysql2';

const RegisterValidators = {
    async registerValidator(data: User) {
        const sql: string = 'SELECT * FROM user WHERE cpf = ?'
        try {
            const [query] = await db.execute<RowDataPacket[]>(sql, [data.cpf]);
    
            if (query.length > 0) {
                return false;
            }
    
            return true;
            
        } catch (err) {
            console.error(err);
            return false;
        }
    },

    async validateCpf(cpf: string) {
        if (cpf.length !== 11 || /^(\d)\1{10}$/.test(cpf)) {
            return false;
        }

        let sum = 0;
        for (let i = 0; i < 9; i++) {
            sum += parseInt(cpf[i]) * (10 - i);
        }
        let rest = (sum * 10) % 11;
        if (rest === 10) rest = 0;
        if (rest !== parseInt(cpf[9])) {
            return false;
        }

        sum = 0
        for (let i = 0; i < 10; i++) {
            sum += parseInt(cpf[i]) * (11 - i);
        }
        rest = (sum * 10) % 11;
        if (rest === 10) rest = 0;
        if (rest !== parseInt(cpf[10])) {
            return false
        }

        return true
    }
}

function validateEmail(email: string): boolean {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
}

export { RegisterValidators, validateEmail};