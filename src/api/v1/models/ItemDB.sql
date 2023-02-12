CREATE DATABASE ItemDB;

CREATE TABLE product_category (
    id INT PRIMARY KEY,
    parent_category_id INT REFERENCES product_category(id),
    category_name VARCHAR(200) NOT NULL
);

CREATE TABLE product (
	id INT PRIMARY KEY,
	category_id INT REFERENCES product_category(id),
	name VARCHAR(200) NOT NULL,
	description TEXT NOT NULL,
	product_image TEXT NOT NULL
);

CREATE TABLE variation (
    id INT PRIMARY KEY,
    category_id INT REFERENCES product_category(id),
    name VARCHAR(200) NOT NULL
);

CREATE TABLE product_item (
    id INT PRIMARY KEY,
    product_id INT REFERENCES product(id),
    SKU INT,
    quantity_in_stock INT,
    product_image TEXT NOT NULL,
    price INT
);

CREATE TABLE variation_option (
    id INT PRIMARY KEY,
    variation_id INT REFERENCES variation(id),
    value TEXT NOT NULL
);

CREATE TABLE product_configuration (
    product_item_id INT REFERENCES product_item(id),
    variation_option_id INT REFERENCES variation_option(id)
);