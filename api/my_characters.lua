local function action_path(name, action)
    return '/my/' .. name .. '/action/' .. action
end

local json = require('dkjson')
local utils = require('api.utils')

local function move(name, x, y)
    local path = action_path(name, 'move')
    local body = json.encode {
        x = x,
        y = y
    }

    return utils.api_request(path, 'POST', body)
end

local function fight(name)
    local path = action_path(name, 'fight')

    return utils.api_request(path, 'POST', nil)
end

local function gathering(name)
    local path = action_path(name, 'gathering')

    return utils.api_request(path, 'POST', nil)
end

local function get_characters()
    local path = '/my/characters'

    return utils.api_request(path, 'GET', nil)
end

return {
    my_characters = get_characters,
    fight = fight,
    gathering = gathering,
    move = move,
}

