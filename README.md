Поднять сервис db_va можно командой:

`docker-compose up otusdb`

Для подключения к БД используйте команду:

`docker-compose exec otusdb mysql -u root -p12345 otus`

Для использования в клиентских приложениях можно использовать команду:

`mysql -u root -p12345 --port=3309 --protocol=tcp otus`

# SQL Запросы для базы данных

## 1. Запрос с INNER JOIN

Этот запрос выбирает все продукты вместе с их соответствующими типами, брендами и продавцами.

```sql
SELECT 
    product.id,
    product.name,
    type.name AS type_name,
    brand.name AS brand_name,
    seller.name AS seller_name,
    product.price
FROM 
    otus.product
INNER JOIN 
    otus.type ON product.type_fk = type.id
INNER JOIN 
    otus.brand ON product.brand_fk = brand.id
INNER JOIN 
    otus.seller ON product.seller_fk = seller.id
WHERE
    seller.name = 'Specific Seller';
```

## 2. Запрос с LEFT JOIN

Этот запрос выбирает всех пользователей вместе с их корзинами, если таковые имеются.

```sql
SELECT
    user.id,
    user.email,
    basket.id AS basket_id
  FROM
      otus.user
          LEFT JOIN
      otus.basket ON user.basket_fk = basket.id;
```

## 3. Запрос с LEFT JOIN

Пять запросов с WHERE с использованием различных операторов

### 1.WHERE с оператором равенства (=)
Этот запрос выбирает все продукты определенного бренда.
```sql
SELECT
    id, name, price
  FROM
      otus.product
 WHERE
     brand_fk = 1;
```
Описание: В проекте этот запрос нужен для фильтрации продуктов по бренду.

### 2.WHERE с оператором больше чем (>)
Этот запрос выбирает все продукты с ценой выше 100.
```sql
SELECT
    id, name, price
  FROM
      otus.product
 WHERE
     price > 100;
```
Описание: В проекте этот запрос нужен для отображения премиальных продуктов.

### 3.WHERE с оператором LIKE
Этот запрос выбирает всех пользователей, у которых в email содержится example.com.
```sql
SELECT
    id, email
  FROM
      otus.user
 WHERE
     email LIKE '%@example.com%';
```
Описание: В проекте этот запрос нужен для фильтрации пользователей по домену электронной почты.

### 4.WHERE с оператором IN
Этот запрос выбирает все продукты определенных типов.
```sql
SELECT
    id, name, price
  FROM
      otus.product
 WHERE
     type_fk IN (1, 2, 3);
```
Описание: В проекте этот запрос нужен для фильтрации продуктов по нескольким типам.

### 5.WHERE с оператором BETWEEN
Этот запрос выбирает все продукты с ценой в диапазоне от 50 до 150.
```sql
SELECT
    id, name, price
  FROM
      otus.product
 WHERE
     price BETWEEN 50 AND 150;
```
Описание: В проекте этот запрос нужен для отображения продуктов средней ценовой категории.


### ДЗ: Типы данных в MySQL

## Изменения в схеме базы данных

### Модификации
1. **Таблица `user`**
    - Добавлен новый столбец `metadata` типа JSON.
        - **Причина**: Для хранения дополнительной информации о пользователях, такой как предпочтения и настройки, в гибком формате JSON.

### Примеры использования данных JSON

#### Вставка данных с использованием JSON
```sql
INSERT INTO otus.user (email,
                       password_hash,
                       metadata)
VALUES ('john@example.com',
        'hashedpassword',
        '{
        "age": 30,
        "preferences": {
            "theme": "dark",
            "notifications": true
        }
    }');
```

#### Выборка данных с использованием JSON
```sql
SELECT *
  FROM otus.user
 WHERE JSON_EXTRACT(metadata, '$.age') > 25
   AND JSON_EXTRACT(metadata, '$.preferences.notifications') = TRUE;
```

### ДЗ: Хранимые процедуры и триггеры

1. Создать пользователей client, manager.
Запрос:
```
CREATE USER 'client'@'localhost' IDENTIFIED BY 'client_password';
CREATE USER 'manager'@'localhost' IDENTIFIED BY 'manager_password';
```
2. Создать процедуру выборки товаров с использованием различных фильтров: категория, цена, производитель, различные дополнительные параметры
   Также в качестве параметров передавать по какому полю сортировать выборку, и параметры постраничной выдачи
Запрос:
```
DELIMITER //

CREATE PROCEDURE otus.get_products(
    IN p_category_id INT,
    IN p_min_price DECIMAL(10, 2),
    IN p_max_price DECIMAL(10, 2),
    IN p_brand_id INT,
    IN p_order_by VARCHAR(50),
    IN p_page INT,
    IN p_page_size INT
)
BEGIN
    SET @sql = CONCAT(
        'SELECT p.id, p.name, p.price, t.name AS category, b.name AS brand ',
        'FROM otus.product p ',
        'JOIN otus.type t ON p.type_fk = t.id ',
        'JOIN otus.brand b ON p.brand_fk = b.id ',
        'WHERE 1 = 1 '
    );

    IF p_category_id IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND p.type_fk = ', p_category_id);
    END IF;

    IF p_min_price IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND p.price >= ', p_min_price);
    END IF;

    IF p_max_price IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND p.price <= ', p_max_price);
    END IF;

    IF p_brand_id IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND p.brand_fk = ', p_brand_id);
    END IF;

    SET @sql = CONCAT(@sql, ' ORDER BY ', p_order_by);

    IF p_page IS NOT NULL AND p_page_size IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' LIMIT ', (p_page - 1) * p_page_size, ', ', p_page_size);
    END IF;

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

GRANT EXECUTE ON PROCEDURE otus.get_products TO 'client'@'localhost';
```
3. Создать процедуру get_orders - которая позволяет просматривать отчет по продажам за определенный период (час, день, неделя) с различными уровнями группировки (по товару, по категории, по производителю)
Запрос:
```
DELIMITER //

CREATE PROCEDURE otus.get_orders(
    IN p_start_date DATETIME,
    IN p_end_date DATETIME,
    IN p_group_by VARCHAR(50)
)
BEGIN
    SET @sql = CONCAT(
        'SELECT '
    );

    CASE
        WHEN p_group_by = 'product' THEN
            SET @sql = CONCAT(@sql, 'p.name AS product, ');
        WHEN p_group_by = 'category' THEN
            SET @sql = CONCAT(@sql, 't.name AS category, ');
        WHEN p_group_by = 'brand' THEN
            SET @sql = CONCAT(@sql, 'b.name AS brand, ');
    END CASE;

    SET @sql = CONCAT(
        @sql, 
        'SUM(o.quantity) AS total_quantity, ',
        'SUM(o.total_price) AS total_sales ',
        'FROM otus.orders o ',
        'JOIN otus.product p ON o.product_fk = p.id ',
        'JOIN otus.type t ON p.type_fk = t.id ',
        'JOIN otus.brand b ON p.brand_fk = b.id ',
        'WHERE o.order_date BETWEEN ', QUOTE(p_start_date), ' AND ', QUOTE(p_end_date), ' '
    );

    CASE
        WHEN p_group_by = 'product' THEN
            SET @sql = CONCAT(@sql, 'GROUP BY p.id');
        WHEN p_group_by = 'category' THEN
            SET @sql = CONCAT(@sql, 'GROUP BY t.id');
        WHEN p_group_by = 'brand' THEN
            SET @sql = CONCAT(@sql, 'GROUP BY b.id');
    END CASE;

    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;
```
4. Права дать пользователю manager
Запрос:
```
GRANT EXECUTE ON PROCEDURE otus.get_orders TO 'manager'@'localhost';
```