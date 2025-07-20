interface User {
    name: string;
    cpf: string;
    dob: string;
    email: string;
    password: string;
    user_type: string;
    company_id?: number;
}

interface Login {
    email: string;
    password: string;
}

export { User, Login }