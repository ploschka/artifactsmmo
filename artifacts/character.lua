local function char_path(name, method)
    return '/my/' .. name .. '/' .. method
end

local json = require('dkjson')
local utils = require('artifacts.utils')

local character = {
    move = function (self, x, y)
        local path = char_path(self.name, 'action/move')
        local body = json.encode {
            x = x,
            y = y
        }

        local resp = utils.api_request(path, 'POST', body)
        if resp.status == 200 then
            self.cooldown = resp.body.data.cooldown
        end
        return resp
    end,
    fight = function (self)
        local path = char_path(self.name, 'action/fight')
        local resp = utils.api_request(path, 'POST', nil)
        if resp.status == 200 then
            self.cooldown = resp.body.data.cooldown
        end
        return resp
    end,
    gathering = function (self)
        local path = char_path(self.name, 'action/gathering')
        local resp = utils.api_request(path, 'POST', nil)
        if resp.status == 200 then
            self.cooldown = resp.body.data.cooldown
        end
    end
}

local mt = {
    __index = character
}

local function new_character(name)
    return setmetatable({name = name}, mt)
end

local function get_characters()
    local path = 'my/characters'
    return utils.api_request(path, 'GET', nil)
end

return {
    new = new_character,
    get_characters = get_characters
}

