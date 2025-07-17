interface Register {
    name: string;
    cpf: string;
    email: string;
    password: string;
    user_type: string;
    company_id?: number;
}

interface Login {
    email: string;
    password: string;
}

export { Register, Login }