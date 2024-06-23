-- Вставка данных в таблицу `type`
INSERT INTO otus.type (name) VALUES
                                 ('Electronics'),
                                 ('Clothing'),
                                 ('Books'),
                                 ('Home Appliances');

-- Вставка данных в таблицу `brand`
INSERT INTO otus.brand (name) VALUES
                                  ('Brand A'),
                                  ('Brand B'),
                                  ('Brand C'),
                                  ('Brand D');

-- Вставка данных в таблицу `seller`
INSERT INTO otus.seller (name) VALUES
                                   ('Seller X'),
                                   ('Seller Y'),
                                   ('Seller Z');

-- Вставка данных в таблицу `product`
INSERT INTO otus.product (name, type_fk, seller_fk, brand_fk, protein_count, fat_count, carbohydrate_count, amount, description, storage_conditions, composition, price, discount) VALUES
                                                                                                                                                                                       ('Laptop', 1, 1, 1, 0, 0, 0, 50, 'High performance laptop', 'Keep in a dry place', 'Plastic, Metal', 999.99, 50),
                                                                                                                                                                                       ('Jeans', 2, 2, 2, 0, 0, 0, 100, 'Comfortable jeans', 'Wash in cold water', 'Denim', 49.99, 10),
                                                                                                                                                                                       ('Science Fiction Book', 3, 3, 3, 0, 0, 0, 200, 'Engaging sci-fi novel', 'Keep away from water', 'Paper', 19.99, 5),
                                                                                                                                                                                       ('Microwave', 4, 1, 4, 0, 0, 0, 30, 'High efficiency microwave', 'Keep in a dry place', 'Plastic, Metal', 149.99, 20),
                                                                                                                                                                                       ('Smartphone', 1, 2, 1, 0, 0, 0, 70, 'Latest model smartphone', 'Keep in a dry place', 'Plastic, Metal', 699.99, 30),
                                                                                                                                                                                       ('T-shirt', 2, 3, 2, 0, 0, 0, 150, '100% cotton T-shirt', 'Wash in cold water', 'Cotton', 19.99, 5),
                                                                                                                                                                                       ('Mystery Novel', 3, 1, 3, 0, 0, 0, 100, 'Thrilling mystery novel', 'Keep away from water', 'Paper', 14.99, 5),
                                                                                                                                                                                       ('Blender', 4, 2, 4, 0, 0, 0, 40, 'High power blender', 'Keep in a dry place', 'Plastic, Metal', 89.99, 15);
