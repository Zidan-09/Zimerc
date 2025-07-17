-- Create the database
CREATE DATABASE IF NOT EXISTS zimerc;
USE zimerc;

-- Company table
CREATE TABLE company (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    cnpj VARCHAR(45) NOT NULL UNIQUE
);

-- User table
CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    user_type ENUM('OWNER', 'EMPLOYEE', 'AMBULANT') NOT NULL,
    company_id INT NULL,
    CONSTRAINT user_company_fk FOREIGN KEY (company_id) REFERENCES company(company_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Product table
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    stock_quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    company_id INT NULL,
    user_id INT NULL,
    CONSTRAINT product_company_fk FOREIGN KEY (company_id) REFERENCES company(company_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT product_user_fk FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Sale table
CREATE TABLE sale (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NULL,
    user_id INT NULL,
    sale_date DATETIME NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    CONSTRAINT sale_company_fk FOREIGN KEY (company_id) REFERENCES company(company_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT sale_user_fk FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Sale_Product table
CREATE TABLE sale_product (
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (sale_id, product_id),
    CONSTRAINT sale_product_sale_fk FOREIGN KEY (sale_id) REFERENCES sale(sale_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT sale_product_product_fk FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE ON UPDATE CASCADE
);