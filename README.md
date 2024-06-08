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
    otus.seller ON product.seller_fk = seller.id;
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
     email LIKE '%example.com%';
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
