package.path = package.path .. ';git/tarantool/tarantool-test/?.lua';

local users = require('users')
local yaml = require('yaml')
local http_router = require('http.router')
local http_server = require('http.server')
local json = require('json')
box.cfg{listen=3301}
users:start()

local user_count = users:length()

if user_count < 100 then
    for n = user_count + 1, 100 do
        users:add({
            id = n,
            first_name = "first_name" .. n,
            last_name = "last_name" .. n,
            surname = "surname" .. n,
            login = "login" .. n,
            password = "password" .. n
        })
    end
end

function get_users(request)
    local limit = tonumber(request:stash('limit'))
    local offset = tonumber(request:stash('page')) * limit
    local body = json.encode(users:get_page(offset, limit))

    return {status = 200, body = body}
end

local httpd = http_server.new('127.0.0.1', 8083, {
    log_requests = true,
    log_errors = true
})

local router = http_router.new()
    :route({
            method = 'GET',
            path = '/users/:page/:limit',
        },
        get_users
    )

httpd:set_router(router)
httpd:start()
