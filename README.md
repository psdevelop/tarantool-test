# tarantool-test
Tarantool test task

для запуска важно прописать правильный путь к модулю
app.lua
package.path = package.path .. ';git/tarantool/tarantool-test/?.lua';

Пример запроса в браузере:
http://localhost:8083/users/2/10

2 - номер страницы, 10 - лимит числа записей на одной странице

устанавливаем модули http сервера, avro_schema

видео-демо https://www.youtube.com/watch?v=obCNYnuk8-o
