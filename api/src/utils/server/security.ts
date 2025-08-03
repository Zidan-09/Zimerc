import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
require('dotenv').config();

const JWT_SECRET = process.env.JWT_SECRET!;
const EXPIRATION = '24h';

export const Security = {
    async hash(password: string) {
        return await bcrypt.hash(password, 10)
    },

    async compare(password: string, hash: string) {
        return await bcrypt.compare(password, hash);
    },

    signLogin(user_id: number, user_type: string) {
        return jwt.sign({ user_id: user_id, user_type: user_type }, JWT_SECRET, { expiresIn: EXPIRATION });
    },

    signLink(id: number) {
        return jwt.sign({id: id}, JWT_SECRET, { expiresIn: EXPIRATION});
    },

    verify(token: string) {
        return jwt.verify(token, JWT_SECRET);
    }
}