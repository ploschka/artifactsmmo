local json = require('dkjson')
local utils = require('api.utils')

local skins = {
    men1 = 'men1',
    men2 = 'men2',
    men3 = 'men3',
    women1 = 'women1',
    women2 = 'women2',
    women3 = 'women3',
}

local function create_character(name, skin)
    local path = '/characters/create'
    local body = json.encode {
        name = name,
        skin = skin,
    }

    return utils.api_request(path, 'POST', body)
end

local function get_character(name)
    local path = '/characters/'..name
    return utils.api_request(path, 'GET', nil)
end

local function delete_character(name)
    local path = '/characters/delete'
    local body = json.encode {
        name = name,
    }

    return utils.api_request(path, 'POST', body)
end

local function get_all_characters()
    local path = '/characters'
    return utils.api_request(path, 'GET', nil)
end

return {
    create = create_character,
    get = get_character,
    delete = delete_character,
    get_all = get_all_characters,
    skins = skins,
}

