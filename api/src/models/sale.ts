interface Sale {
    company_id?: number;
    user_id?: number;
    sale_date: Date;
    total_amount: number;
    latitude?: number;
    longitude?: number
}

interface Sale_Product {
    product_id: number;
    quantity: number;
    unit_price: number;
}