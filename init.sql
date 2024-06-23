-- Создаем таблицы
CREATE SCHEMA IF NOT EXISTS otus;

-- Создание таблицы "basket"
CREATE TABLE IF NOT EXISTS otus.basket
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY
    );

-- Пример создания таблицы "user"
CREATE TABLE IF NOT EXISTS otus.user
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        email VARCHAR(255) NOT NULL
    UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    basket_fk INT,
    FOREIGN KEY (basket_fk) REFERENCES otus.basket (id)
    );

CREATE TABLE IF NOT EXISTS otus.type
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    UNIQUE
    );

CREATE TABLE IF NOT EXISTS otus.brand
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    UNIQUE
    );

CREATE TABLE IF NOT EXISTS otus.seller
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    UNIQUE
    );

CREATE TABLE IF NOT EXISTS otus.product
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
    type_fk INT,
    seller_fk INT,
    brand_fk INT,
    protein_count DECIMAL(10, 2)
    CHECK ( protein_count >= 0 ),
    fat_count DECIMAL(10, 2)
    CHECK ( fat_count >= 0 ),
    carbohydrate_count DECIMAL(10, 2)
    CHECK ( carbohydrate_count >= 0 ),
    amount INT
    CHECK ( amount >= 0 ),
    description TEXT,
    storage_conditions TEXT,
    composition TEXT,
    price DECIMAL(10, 2)
    CHECK ( price >= 0 ),
    discount DECIMAL(10, 2)
    CHECK ( discount >= 0 ),
    FOREIGN KEY (type_fk) REFERENCES otus.type (id),
    FOREIGN KEY (seller_fk) REFERENCES otus.seller (id),
    FOREIGN KEY (brand_fk) REFERENCES otus.brand (id)
    );

CREATE TABLE IF NOT EXISTS otus.review
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        user_fk INT,
        rating INT
        CHECK ( rating >= 0 AND rating <= 5 ),
    text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_fk) REFERENCES otus.user (id)
    );

CREATE TABLE IF NOT EXISTS otus.review_product
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        product_fk INT,
        review_fk INT,
        FOREIGN KEY (product_fk) REFERENCES otus.product (id),
    FOREIGN KEY (review_fk) REFERENCES otus.review (id)
    );

CREATE TABLE IF NOT EXISTS otus.question
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        user_fk INT,
        question_text TEXT,
        question_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_fk) REFERENCES otus.user (id)
    );

CREATE TABLE IF NOT EXISTS otus.answer
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        user_fk INT,
        answer_text TEXT,
        answer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_fk) REFERENCES otus.user (id)
    );

CREATE TABLE IF NOT EXISTS otus.question_product
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        product_fk INT,
        question_fk INT,
        FOREIGN KEY (product_fk) REFERENCES otus.product (id),
    FOREIGN KEY (question_fk) REFERENCES otus.question (id)
    );

CREATE TABLE IF NOT EXISTS otus.answer_question
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        question_fk INT,
        answer_fk INT,
        FOREIGN KEY (question_fk) REFERENCES otus.question (id),
    FOREIGN KEY (answer_fk) REFERENCES otus.answer (id)
    );

-- Создание таблицы "user_contact"
CREATE TABLE IF NOT EXISTS otus.user_contact
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        user_fk INT,
        contact_type VARCHAR(255),
    contact_value VARCHAR(255),
    is_primary BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_fk) REFERENCES otus.user (id)
    );

-- Добавление индексов для оптимизации запросов
CREATE INDEX idx_product_name ON otus.product (name);
CREATE INDEX idx_product_type ON otus.product (type_fk);
CREATE INDEX idx_review_product ON otus.review_product (product_fk);
CREATE INDEX idx_question_product ON otus.question_product (product_fk);

-- Создание таблицы "product_image"
CREATE TABLE IF NOT EXISTS otus.product_image
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        product_fk INT,
        image_url VARCHAR(255) NOT NULL,
    FOREIGN KEY (product_fk) REFERENCES otus.product (id)
    );

-- Создание таблицы "order"
CREATE TABLE IF NOT EXISTS otus.order
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        user_fk INT,
        order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10, 2)
    CHECK ( total_amount >= 0 ),
    FOREIGN KEY (user_fk) REFERENCES otus.user (id)
    );

-- Создание таблицы "order_item"
CREATE TABLE IF NOT EXISTS otus.order_item
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        order_fk INT,
        product_fk INT,
        quantity INT
        CHECK ( quantity > 0 ),
    price DECIMAL(10, 2)
    CHECK ( price >= 0 ),
    FOREIGN KEY (order_fk) REFERENCES otus.order (id),
    FOREIGN KEY (product_fk) REFERENCES otus.product (id)
    );

-- Создание таблицы "cart"
CREATE TABLE IF NOT EXISTS otus.cart
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        user_fk INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_fk) REFERENCES otus.user (id)
    );

-- Создание таблицы "cart_item"
CREATE TABLE IF NOT EXISTS otus.cart_item
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        cart_fk INT,
        product_fk INT,
        quantity INT
        CHECK ( quantity > 0 ),
    FOREIGN KEY (cart_fk) REFERENCES otus.cart (id),
    FOREIGN KEY (product_fk) REFERENCES otus.product (id)
    );

-- Создание таблицы "wishlist"
CREATE TABLE IF NOT EXISTS otus.wishlist
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        user_fk INT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_fk) REFERENCES otus.user (id)
    );

-- Создание таблицы "wishlist_item"
CREATE TABLE IF NOT EXISTS otus.wishlist_item
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        wishlist_fk INT,
        product_fk INT,
        FOREIGN KEY (wishlist_fk) REFERENCES otus.wishlist (id),
    FOREIGN KEY (product_fk) REFERENCES otus.product (id)
    );

-- Создание таблицы "payment"
CREATE TABLE IF NOT EXISTS otus.payment
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        order_fk INT,
        payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        amount DECIMAL(10, 2)
    CHECK ( amount >= 0 ),
    payment_method VARCHAR(50) NOT NULL,
    FOREIGN KEY (order_fk) REFERENCES otus.order (id)
    );

-- Создание таблицы "shipment"
CREATE TABLE IF NOT EXISTS otus.shipment
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        order_fk INT,
        shipment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        shipment_method VARCHAR(50) NOT NULL,
    tracking_number VARCHAR(100),
    FOREIGN KEY (order_fk) REFERENCES otus.order (id)
    );

-- Добавление индексов для оптимизации запросов
CREATE INDEX idx_user_email ON otus.user (email);
CREATE INDEX idx_order_user ON otus.order (user_fk);
CREATE INDEX idx_cart_user ON otus.cart (user_fk);
CREATE INDEX idx_wishlist_user ON otus.wishlist (user_fk);
CREATE INDEX idx_payment_order ON otus.payment (order_fk);
CREATE INDEX idx_shipment_order ON otus.shipment (order_fk);

-- Помните, что индексы следует создавать осознанно, так как они ускоряют чтение данных, но могут замедлить операции записи.
-- Создание таблицы "address"
CREATE TABLE IF NOT EXISTS otus.address
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        user_fk INT,
        street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    zip_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_fk) REFERENCES otus.user (id)
    );

-- Создание таблицы "promotion"
CREATE TABLE IF NOT EXISTS otus.promotion
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
    description TEXT,
    discount DECIMAL(10, 2)
    CHECK ( discount >= 0 AND discount <= 100 ),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
    );

-- Создание таблицы "product_promotion"
CREATE TABLE IF NOT EXISTS otus.product_promotion
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        product_fk INT,
        promotion_fk INT,
        FOREIGN KEY (product_fk) REFERENCES otus.product (id),
    FOREIGN KEY (promotion_fk) REFERENCES otus.promotion (id)
    );

-- Создание таблицы "category"
CREATE TABLE IF NOT EXISTS otus.category
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    UNIQUE,
    parent_fk INT,
    FOREIGN KEY (parent_fk) REFERENCES otus.category (id)
    );

-- Создание таблицы "product_category"
CREATE TABLE IF NOT EXISTS otus.product_category
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        product_fk INT,
        category_fk INT,
        FOREIGN KEY (product_fk) REFERENCES otus.product (id),
    FOREIGN KEY (category_fk) REFERENCES otus.category (id)
    );

-- Создание таблицы "tag"
CREATE TABLE IF NOT EXISTS otus.tag
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    UNIQUE
    );

-- Создание таблицы "product_tag"
CREATE TABLE IF NOT EXISTS otus.product_tag
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        product_fk INT,
        tag_fk INT,
        FOREIGN KEY (product_fk) REFERENCES otus.product (id),
    FOREIGN KEY (tag_fk) REFERENCES otus.tag (id)
    );

-- Создание таблицы "log"
CREATE TABLE IF NOT EXISTS otus.log
    (
        id INT AUTO_INCREMENT
        PRIMARY KEY,
        user_fk INT,
        action VARCHAR(255) NOT NULL,
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_fk) REFERENCES otus.user (id)
    );

-- Добавление индексов для оптимизации запросов
CREATE INDEX idx_address_user ON otus.address (user_fk);
CREATE INDEX idx_promotion_date ON otus.promotion (start_date, end_date);
CREATE INDEX idx_product_promotion_product ON otus.product_promotion (product_fk);
CREATE INDEX idx_product_promotion_promotion ON otus.product_promotion (promotion_fk);
CREATE INDEX idx_category_parent ON otus.category (parent_fk);
CREATE INDEX idx_product_category_product ON otus.product_category (product_fk);
CREATE INDEX idx_product_category_category ON otus.product_category (category_fk);
CREATE INDEX idx_product_tag_product ON otus.product_tag (product_fk);
CREATE INDEX idx_product_tag_tag ON otus.product_tag (tag_fk);
CREATE INDEX idx_log_user ON otus.log (user_fk);

ALTER TABLE otus.user
    ADD COLUMN metadata json;

