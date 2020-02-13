# tarantool-test
Tarantool test task

для запуска важно прописать правильный путь к модулю
app.lua
package.path = package.path .. ';git/tarantool/tarantool-test/?.lua';

Пример запроса в браузере:
http://localhost:8083/users/2/10

2 - номер страницы, 10 - лимит числа записей на одной странице

устанавливаем модули http сервера (https://github.com/tarantool/http), 
avro_schema

видео-демо https://www.youtube.com/watch?v=obCNYnuk8-o

материалы по tarantool
https://github.com/tarantool/vshard/tree/master/example
https://www.tarantool.io/ru/doc/1.10/reference/reference_rock/vshard/vshard_ref/#router-api-bucket-id
https://www.tarantool.io/ru/doc/1.10/book/getting_started/using_binary/
https://github.com/tarantool/tarantool
https://www.tarantool.io/ru/doc/1.10/book/getting_started/using_docker/

