Поднять сервис db_va можно командой:

`docker-compose up otusdb`

Для подключения к БД используйте команду:

`docker-compose exec otusdb mysql -u root -p12345 otus`

Для использования в клиентских приложениях можно использовать команду:

`mysql -u root -p12345 --port=3309 --protocol=tcp otus`

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