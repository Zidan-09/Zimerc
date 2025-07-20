import { Company } from "./company";
import { User } from "./user";

export interface RegisterData {
    user: User,
    company: Company
}