local avro = require('avro_schema')
local log = require('log')

local schema = {
    user = {
        type="record",
        name="user_schema",
        fields={
            {name="id", type="long"},
            {name="first_name", type="string"},
            {name="last_name", type="string"},
            {name="surname", type="string"},
            {name="login", type="string"},
            {name="password", type="string"}
        }
    }
}

local user_dict = {
    user_model = {},

    -- create api object
    start = function(self)
        -- create spaces and indexes
        box.once('init', function()
            box.schema.create_space('users')
            box.space.users:create_index(
                "primary", {type = 'hash', parts = {1, 'unsigned'}}
            )
            box.space.users:create_index(
                "full_name", {type = "tree", parts = { {3, 'string'}, {2, 'string'}, {4, 'string'} }}
            )
        end)

        -- create model
        local ok_u, user = avro.create(schema.user)
        if ok_u then
            -- compile model
            local ok_usr, compiled_user = avro.compile(user)
            if ok_usr then
                self.user_model = compiled_user
                log.info('Init api')
                return true
            else
                log.error('Schema compilation failed')
            end
        else
            log.info('Schema creation failed')
        end
        return false
    end,

    -- return space capacity
    length = function(self)
        return box.space.users:len()
    end,

    -- return page of users list
    -- with offset and limit
    get_page = function(self, offset, limit)
        local result = {}
        for _, tuple in ipairs(box.space.users:select(nil,
                {limit = limit, offset = offset})) do
            local ok, user = self.user_model.unflatten(tuple)
            table.remove(user, 6)
            table.insert(result, user)
        end
        return result
    end,

    -- add user to map and store it in Tarantool
    add = function(self, user)
        local ok, tuple = self.user_model.flatten(user)
        if not ok then
            return false
        end
        box.space.users:replace(tuple)
        return true
    end
}

return user_dict
